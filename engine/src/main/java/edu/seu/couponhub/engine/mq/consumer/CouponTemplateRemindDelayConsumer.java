package edu.seu.couponhub.engine.mq.consumer;

import cn.hutool.core.bean.BeanUtil;
import com.alibaba.fastjson2.JSON;
import edu.seu.couponhub.engine.common.constant.EngineRockerMQConstant;
import edu.seu.couponhub.engine.mq.base.MessageWrapper;
import edu.seu.couponhub.engine.mq.event.CouponTemplateRemindDelayEvent;
import edu.seu.couponhub.engine.service.handler.remind.CouponTemplateRemindExecutor;
import edu.seu.couponhub.engine.service.handler.remind.dto.CouponTemplateRemindDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.stereotype.Component;

/**
 * 提醒抢券消费者
 * <p>
 */
@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
        topic = EngineRockerMQConstant.COUPON_TEMPLATE_REMIND_TOPIC_KEY,
        consumerGroup = EngineRockerMQConstant.COUPON_TEMPLATE_REMIND_CG_KEY
)
@Slf4j(topic = "CouponTemplateRemindDelayConsumer")
public class CouponTemplateRemindDelayConsumer implements RocketMQListener<MessageWrapper<CouponTemplateRemindDelayEvent>> {

    private final CouponTemplateRemindExecutor couponTemplateRemindExecutor;

    @Override
    public void onMessage(MessageWrapper<CouponTemplateRemindDelayEvent> messageWrapper) {
        log.info("[消费者] 提醒用户抢券 - 执行消费逻辑，消息体：{}", JSON.toJSONString(messageWrapper));

        CouponTemplateRemindDelayEvent event = messageWrapper.getMessage();
        CouponTemplateRemindDTO couponTemplateRemindDTO = BeanUtil.toBean(event, CouponTemplateRemindDTO.class);

        // 根据不同策略向用户发送消息提醒
        couponTemplateRemindExecutor.executeRemindCouponTemplate(couponTemplateRemindDTO);
    }
}
