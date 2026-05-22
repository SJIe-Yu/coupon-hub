package edu.seu.couponhub.merchant.admin.common.constant;

/**
 * 商家后管优惠券 RocketMQ 常量类
 * <p>
 */
public final class MerchantAdminRocketMQConstant {

    /**
     * 优惠券推送任务定时执行 Topic Key
     */
    public static final String TEMPLATE_TASK_DELAY_TOPIC_KEY = "coupon-hub-merchant-admin-service-coupon-task-delay-topic${unique-name:}";

    /**
     * 优惠券推送任务定时执行-变更记录发送状态消费者组 Key
     */
    public static final String TEMPLATE_TASK_DELAY_STATUS_CG_KEY = "coupon-hub-merchant-admin-service-coupon-task-delay-status-cg${unique-name:}";

    /**
     * 优惠券模板推送定时执行 Topic Key
     */
    public static final String TEMPLATE_DELAY_TOPIC_KEY = "coupon-hub-merchant-admin-service-coupon-template-delay-topic${unique-name:}";

    /**
     * 优惠券模板推送定时执行-变更记录状态消费者组 Key
     */
    public static final String TEMPLATE_DELAY_STATUS_CG_KEY = "coupon-hub-merchant-admin-service-coupon-template-delay-status-cg${unique-name:}";

    /**
     * 优惠券模板推送执行 Topic Key
     * 负责扫描优惠券 Excel 并将里面的记录进行推送
     */
    public static final String TEMPLATE_TASK_EXECUTE_TOPIC_KEY = "coupon-hub-distribution-service-coupon-task-execute-topic${unique-name:}";
}
