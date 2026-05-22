package edu.seu.couponhub.distribution.common.constant;

/**
 * 分布式 Redis 缓存引擎层常量类
 * <p>
 */
public final class EngineRedisConstant {

    /**
     * 优惠券模板缓存 Key
     */
    public static final String COUPON_TEMPLATE_KEY = "coupon-hub-engine:template:%s";

    /**
     * 用户已领取优惠券列表模板 Key
     */
    public static final String USER_COUPON_TEMPLATE_LIST_KEY = "coupon-hub-engine:user-template-list:";

    /**
     * 限制用户领取优惠券模板次数缓存 Key
     */
    public static final String USER_COUPON_TEMPLATE_LIMIT_KEY = "coupon-hub-engine:user-template-limit:";
}
