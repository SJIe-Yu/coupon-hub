package edu.seu.couponhub.distribution.mq.consumer;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson2.JSON;
import edu.seu.couponhub.distribution.common.constant.DistributionRocketMQConstant;
import edu.seu.couponhub.distribution.common.enums.SendMessageMarkCovertEnum;
import edu.seu.couponhub.distribution.mq.base.MessageWrapper;
import edu.seu.couponhub.distribution.mq.event.CouponTemplateDistributionEvent;
import edu.seu.couponhub.distribution.service.basics.DistributionExecuteStrategy;
import edu.seu.couponhub.distribution.service.basics.DistributionStrategyChoose;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.stereotype.Component;

import java.util.List;


@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
        topic = DistributionRocketMQConstant.TEMPLATE_EXECUTE_DISTRIBUTION_TOPIC_KEY,
        consumerGroup = DistributionRocketMQConstant.TEMPLATE_EXECUTE_SEND_MESSAGE_CG_KEY
)
@Slf4j(topic = "CouponExecuteDistributionConsumer")
public class CouponExecuteSendMessageConsumer implements RocketMQListener<MessageWrapper<CouponTemplateDistributionEvent>> {

    private final DistributionStrategyChoose distributionStrategyChoose;

    @Override
    public void onMessage(MessageWrapper<CouponTemplateDistributionEvent> messageWrapper) {
        log.info("[消费者] 优惠券任务执行推送@发送用户消息通知 - 执行消费逻辑，消息体：{}", JSON.toJSONString(messageWrapper));

        // 通知 Excel 解析完成进行兜底保存数据库，本消费者直接跳过，CouponExecuteDistributionConsumer 有效
        if (messageWrapper.getMessage().getDistributionEndFlag()) {
            return;
        }

        // 获取通知类型调用发送接口执行通知逻辑
        String notifyType = messageWrapper.getMessage().getNotifyType();
        List<String> notifyTypes = StrUtil.split(notifyType, ",");
        notifyTypes.parallelStream().forEach(each -> {
            DistributionExecuteStrategy executeStrategy = distributionStrategyChoose.choose(SendMessageMarkCovertEnum.fromType(Integer.parseInt(each)));
            executeStrategy.executeResp(null);
        });
    }
}
