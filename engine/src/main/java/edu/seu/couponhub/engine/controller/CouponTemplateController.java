package edu.seu.couponhub.engine.controller;

import edu.seu.couponhub.engine.dto.req.CouponTemplateQueryReqDTO;
import edu.seu.couponhub.engine.dto.resp.CouponTemplateQueryRespDTO;
import edu.seu.couponhub.engine.service.CouponTemplateService;
import edu.seu.couponhub.framework.result.Result;
import edu.seu.couponhub.framework.web.Results;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 优惠券模板控制层
 * <p>
 */
@RestController
@RequiredArgsConstructor
@Tag(name = "优惠券模板管理")
public class CouponTemplateController {

    private final CouponTemplateService couponTemplateService;

    @Operation(summary = "查询优惠券模板")
    @GetMapping("/api/engine/coupon-template/query")
    public Result<CouponTemplateQueryRespDTO> findCouponTemplate(CouponTemplateQueryReqDTO requestParam) {
        return Results.success(couponTemplateService.findCouponTemplate(requestParam));
    }
}
