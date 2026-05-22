package edu.seu.couponhub.api.remote;

import edu.seu.couponhub.api.dto.req.CouponTemplateStockDecrementReqDTO;
import edu.seu.couponhub.api.dto.resp.CouponTemplateQueryRespDTO;
import edu.seu.couponhub.framework.result.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 商家后台远程服务
 * <p>
 */
@FeignClient(name = "coupon-hub-merchant-admin")
public interface MerchantAdminRemoteService {

    /**
     * 查询优惠券模板详情
     */
    @GetMapping("/api/merchant-admin/coupon-template/remote/query")
    Result<CouponTemplateQueryRespDTO> findCouponTemplate(
            @RequestParam("shopNumber") String shopNumber,
            @RequestParam("couponTemplateId") String couponTemplateId
    );

    /**
     * 扣减优惠券模板库存
     */
    @PostMapping("/api/merchant-admin/coupon-template/remote/decrement-stock")
    Result<Void> decrementCouponTemplateStock(@RequestBody CouponTemplateStockDecrementReqDTO requestParam);
}
