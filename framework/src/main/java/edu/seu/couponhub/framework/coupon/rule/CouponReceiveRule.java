package edu.seu.couponhub.framework.coupon.rule;

import lombok.Data;

/**
 * 优惠券领取规则。
 */
@Data
public class CouponReceiveRule {

    /**
     * 每人限领数量。
     */
    private Integer limitPerPerson;

    /**
     * 使用说明。
     */
    private String usageInstructions;
}
