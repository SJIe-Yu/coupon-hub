package edu.seu.couponhub.merchant.admin.service.handler.filter;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import edu.seu.couponhub.framework.coupon.rule.CouponRuleUtil;
import edu.seu.couponhub.framework.exception.ClientException;
import edu.seu.couponhub.merchant.admin.common.enums.DiscountTargetEnum;
import edu.seu.couponhub.merchant.admin.common.enums.DiscountTypeEnum;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateSaveReqDTO;
import edu.seu.couponhub.merchant.admin.service.basics.chain.MerchantAdminAbstractChainHandler;
import org.springframework.stereotype.Component;

import java.util.Arrays;

import static edu.seu.couponhub.merchant.admin.common.enums.ChainBizMarkEnum.MERCHANT_ADMIN_CREATE_COUPON_TEMPLATE_KEY;

/**
 * 验证优惠券创建接口参数是否正确责任链｜验证参数基本数据关系是否正确
 * <p>
 */
@Component
public class CouponTemplateCreateParamBaseVerifyChainFilter implements MerchantAdminAbstractChainHandler<CouponTemplateSaveReqDTO> {

    private final int maxStock = 20000000;

    @Override
    public void handler(CouponTemplateSaveReqDTO requestParam) {
        boolean targetAnyMatch = Arrays.stream(DiscountTargetEnum.values())
                .anyMatch(enumConstant -> enumConstant.getType() == requestParam.getTarget());
        if (!targetAnyMatch) {
            // 此处已经基本能判断数据请求属于恶意攻击，可以上报风控中心进行封禁账号
            throw new ClientException("优惠对象值不存在");
        }
        if (ObjectUtil.equal(requestParam.getTarget(), DiscountTargetEnum.ALL_STORE_GENERAL.getType())
                && StrUtil.isNotEmpty(requestParam.getGoods())) {
            throw new ClientException("优惠券全店通用不可设置指定商品");
        }
        if (ObjectUtil.equal(requestParam.getTarget(), DiscountTargetEnum.PRODUCT_SPECIFIC.getType())
                && StrUtil.isEmpty(requestParam.getGoods())) {
            throw new ClientException("优惠券商品专属未设置指定商品");
        }

        boolean typeAnyMatch = Arrays.stream(DiscountTypeEnum.values())
                .anyMatch(enumConstant -> enumConstant.getType() == requestParam.getType());
        if (!typeAnyMatch) {
            // 此处已经基本能判断数据请求属于恶意攻击，可以上报风控中心进行封禁账号
            throw new ClientException("优惠类型不存在");
        }

        if (requestParam.getStock() <= 0 || requestParam.getStock() > maxStock) {
            // 此处已经基本能判断数据请求属于恶意攻击，可以上报风控中心进行封禁账号
            throw new ClientException("库存数量设置异常");
        }

        CouponRuleUtil.validateReceiveRule(requestParam.getReceiveRule());
        CouponRuleUtil.validateConsumeRule(requestParam.getConsumeRule(), requestParam.getType());
    }

    @Override
    public String mark() {
        return MERCHANT_ADMIN_CREATE_COUPON_TEMPLATE_KEY.name();
    }

    @Override
    public int getOrder() {
        return 10;
    }
}
