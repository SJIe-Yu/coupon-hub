package edu.seu.couponhub.framework.coupon.rule;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson2.JSON;
import edu.seu.couponhub.framework.exception.ClientException;

import java.math.BigDecimal;
import java.util.Objects;

/**
 * 优惠券规则 JSON 解析与校验工具。
 */
public final class CouponRuleUtil {

    private CouponRuleUtil() {
    }

    public static CouponReceiveRule parseReceiveRule(String receiveRule) {
        if (!JSON.isValid(receiveRule)) {
            throw new ClientException("领取规则格式错误");
        }
        CouponReceiveRule rule = JSON.parseObject(receiveRule, CouponReceiveRule.class);
        if (Objects.isNull(rule)) {
            throw new ClientException("领取规则格式错误");
        }
        return rule;
    }

    public static CouponConsumeRule parseConsumeRule(String consumeRule) {
        if (!JSON.isValid(consumeRule)) {
            throw new ClientException("消耗规则格式错误");
        }
        CouponConsumeRule rule = JSON.parseObject(consumeRule, CouponConsumeRule.class);
        if (Objects.isNull(rule)) {
            throw new ClientException("消耗规则格式错误");
        }
        return rule;
    }

    public static void validateReceiveRule(String receiveRule) {
        CouponReceiveRule rule = parseReceiveRule(receiveRule);
        if (Objects.isNull(rule.getLimitPerPerson()) || rule.getLimitPerPerson() <= 0) {
            throw new ClientException("每人限领数量不能为空且必须大于 0");
        }
        if (StrUtil.isBlank(rule.getUsageInstructions())) {
            throw new ClientException("优惠券使用说明不能为空");
        }
    }

    public static void validateConsumeRule(String consumeRule, Integer couponType) {
        CouponConsumeRule rule = parseConsumeRule(consumeRule);
        if (Objects.isNull(rule.getTermsOfUse()) || rule.getTermsOfUse().compareTo(BigDecimal.ZERO) < 0) {
            throw new ClientException("优惠券使用门槛不能为空且不能小于 0");
        }
        if (Objects.isNull(rule.getMaximumDiscountAmount()) || rule.getMaximumDiscountAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ClientException("最大优惠金额不能为空且必须大于 0");
        }
        if (Objects.isNull(rule.getValidityPeriod()) || rule.getValidityPeriod() <= 0) {
            throw new ClientException("优惠券领取后有效期不能为空且必须大于 0");
        }
        if (Objects.equals(couponType, 2)
                && (Objects.isNull(rule.getDiscountRate())
                || rule.getDiscountRate().compareTo(BigDecimal.ZERO) <= 0
                || rule.getDiscountRate().compareTo(BigDecimal.ONE) >= 0)) {
            throw new ClientException("折扣券折扣率不能为空且必须在 0 到 1 之间");
        }
    }
}
