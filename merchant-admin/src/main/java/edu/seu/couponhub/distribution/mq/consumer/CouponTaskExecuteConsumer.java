package edu.seu.couponhub.distribution.mq.consumer;

import cn.hutool.core.util.ObjectUtil;
import com.alibaba.excel.EasyExcel;
import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import edu.seu.couponhub.distribution.common.constant.DistributionRocketMQConstant;
import edu.seu.couponhub.distribution.common.enums.CouponTaskStatusEnum;
import edu.seu.couponhub.distribution.common.enums.CouponTemplateStatusEnum;
import edu.seu.couponhub.distribution.dao.entity.CouponTemplateDO;
import edu.seu.couponhub.distribution.dao.mapper.CouponTaskFailMapper;
import edu.seu.couponhub.distribution.dao.mapper.CouponTaskMapper;
import edu.seu.couponhub.distribution.dao.mapper.CouponTemplateMapper;
import edu.seu.couponhub.distribution.mq.base.MessageWrapper;
import edu.seu.couponhub.distribution.mq.event.CouponTaskExecuteEvent;
import edu.seu.couponhub.distribution.mq.producer.CouponExecuteDistributionProducer;
import edu.seu.couponhub.distribution.service.handler.excel.CouponTaskExcelObject;
import edu.seu.couponhub.distribution.service.handler.excel.ReadExcelDistributionListener;
import edu.seu.couponhub.framework.idempotent.NoMQDuplicateConsume;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

/**
 * 优惠券推送定时执行-真实执行消费者
 * <p>
 */
@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
        topic = DistributionRocketMQConstant.TEMPLATE_TASK_EXECUTE_TOPIC_KEY,
        consumerGroup = DistributionRocketMQConstant.TEMPLATE_TASK_EXECUTE_CG_KEY
)
@Slf4j(topic = "CouponTaskExecuteConsumer")
public class CouponTaskExecuteConsumer implements RocketMQListener<MessageWrapper<CouponTaskExecuteEvent>> {

    private final CouponTaskMapper couponTaskMapper;
    private final CouponTemplateMapper couponTemplateMapper;
    private final CouponTaskFailMapper couponTaskFailMapper;

    private final StringRedisTemplate stringRedisTemplate;
    private final CouponExecuteDistributionProducer couponExecuteDistributionProducer;

    @NoMQDuplicateConsume(
            keyPrefix = "coupon_task_execute:idempotent:",
            key = "#messageWrapper.message.couponTaskId",
            keyTimeout = 120
    )
    @Override
    public void onMessage(MessageWrapper<CouponTaskExecuteEvent> messageWrapper) {
        log.info("[消费者] 优惠券推送任务正式执行 - 执行消费逻辑，消息体：{}", JSON.toJSONString(messageWrapper));

        var couponTaskId = messageWrapper.getMessage().getCouponTaskId();
        var couponTaskDO = couponTaskMapper.selectById(couponTaskId);
        // 判断优惠券模板发送状态是否为执行中，如果不是有可能是被取消状态
        if (ObjectUtil.notEqual(couponTaskDO.getStatus(), CouponTaskStatusEnum.IN_PROGRESS.getStatus())) {
            log.warn("[消费者] 优惠券推送任务正式执行 - 推送任务记录状态异常：{}，已终止推送", couponTaskDO.getStatus());
            return;
        }

        // 判断优惠券状态是否正确
        var queryWrapper = Wrappers.lambdaQuery(CouponTemplateDO.class)
                .eq(CouponTemplateDO::getId, couponTaskDO.getCouponTemplateId())
                .eq(CouponTemplateDO::getShopNumber, couponTaskDO.getShopNumber());
        var couponTemplateDO = couponTemplateMapper.selectOne(queryWrapper);
        var status = couponTemplateDO.getStatus();
        if (ObjectUtil.notEqual(status, CouponTemplateStatusEnum.ACTIVE.getStatus())) {
            log.error("[消费者] 优惠券推送任务正式执行 - 优惠券ID：{}，优惠券模板状态：{}", couponTaskDO.getCouponTemplateId(), status);
            return;
        }

        // 正式开始执行优惠券推送任务
        ReadExcelDistributionListener readExcelDistributionListener = new ReadExcelDistributionListener(
                couponTaskDO,
                couponTemplateDO,
                couponTaskFailMapper,
                stringRedisTemplate,
                couponExecuteDistributionProducer
        );
        EasyExcel.read(couponTaskDO.getFileAddress(), CouponTaskExcelObject.class, readExcelDistributionListener).sheet().doRead();
    }
}
