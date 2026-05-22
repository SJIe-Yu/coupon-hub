package edu.seu.couponhub.merchant.admin.service.handler.filter;

import cn.hutool.core.util.ObjectUtil;
import edu.seu.couponhub.merchant.admin.common.enums.DiscountTargetEnum;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateSaveReqDTO;
import edu.seu.couponhub.merchant.admin.service.basics.chain.MerchantAdminAbstractChainHandler;
import org.springframework.stereotype.Component;

import static edu.seu.couponhub.merchant.admin.common.enums.ChainBizMarkEnum.MERCHANT_ADMIN_CREATE_COUPON_TEMPLATE_KEY;

/**
 * 验证优惠券创建接口参数是否正确责任链｜验证参数数据是否正确
 * <p>
 */
@Component
public class CouponTemplateCreateParamVerifyChainFilter implements MerchantAdminAbstractChainHandler<CouponTemplateSaveReqDTO> {

    @Override
    public void handler(CouponTemplateSaveReqDTO requestParam) {
        if (ObjectUtil.equal(requestParam.getTarget(), DiscountTargetEnum.PRODUCT_SPECIFIC.getType())) {
            // 调用商品中台验证商品是否存在，如果不存在抛出异常
            // ......
        }
    }

    @Override
    public String mark() {
        return MERCHANT_ADMIN_CREATE_COUPON_TEMPLATE_KEY.name();
    }

    @Override
    public int getOrder() {
        return 20;
    }
}
