package edu.seu.couponhub.framework.coupon.rule;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 优惠券消耗规则。
 */
@Data
public class CouponConsumeRule {

    /**
     * 使用门槛，满多少金额可用。
     */
    private BigDecimal termsOfUse;

    /**
     * 最大优惠金额。
     */
    private BigDecimal maximumDiscountAmount;

    /**
     * 折扣券折扣率。
     */
    private BigDecimal discountRate;

    /**
     * 领取后有效期，单位小时。
     */
    private Integer validityPeriod;

    /**
     * 未满足使用条件时的说明。
     */
    private String explanationOfUnmetConditions;
}
