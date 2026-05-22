package edu.seu.couponhub.distribution.common.constant;

/**
 * 分发优惠券服务 RocketMQ 常量类
 * <p>
 */
public final class DistributionRocketMQConstant {

    /**
     * 优惠券模板推送执行 Topic Key
     * 负责扫描优惠券 Excel 并将里面的记录进行推送
     */
    public static final String TEMPLATE_TASK_EXECUTE_TOPIC_KEY = "coupon-hub-distribution-service-coupon-task-execute-topic${unique-name:}";

    /**
     * 优惠券模板推送执行-执行消费者组 Key
     */
    public static final String TEMPLATE_TASK_EXECUTE_CG_KEY = "coupon-hub-distribution-service-coupon-task-execute-cg${unique-name:}";

    /**
     * 优惠券模板推送执行 Topic Key
     * 负责执行将优惠券发放给具体用户逻辑
     */
    public static final String TEMPLATE_EXECUTE_DISTRIBUTION_TOPIC_KEY = "coupon-hub-distribution-service-coupon-execute-distribution-topic${unique-name:}";

    /**
     * 优惠券模板推送执行-执行消费者组 Key
     */
    public static final String TEMPLATE_EXECUTE_DISTRIBUTION_CG_KEY = "coupon-hub-distribution-service-coupon-execute-distribution-cg${unique-name:}";

    /**
     * 优惠券模板推送用户通知-执行消费者组 Key
     */
    public static final String TEMPLATE_EXECUTE_SEND_MESSAGE_CG_KEY = "coupon-hub-distribution-service-coupon-execute-send-message-cg${unique-name:}";
}
