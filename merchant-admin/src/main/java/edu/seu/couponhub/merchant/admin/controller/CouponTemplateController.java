package edu.seu.couponhub.merchant.admin.controller;

import cn.hutool.core.bean.BeanUtil;
import edu.seu.couponhub.api.dto.req.CouponTemplateStockDecrementReqDTO;
import com.baomidou.mybatisplus.core.metadata.IPage;
import edu.seu.couponhub.framework.idempotent.NoDuplicateSubmit;
import edu.seu.couponhub.framework.result.Result;
import edu.seu.couponhub.framework.web.Results;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateNumberReqDTO;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplatePageQueryReqDTO;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateSaveReqDTO;
import edu.seu.couponhub.merchant.admin.dto.resp.CouponTemplatePageQueryRespDTO;
import edu.seu.couponhub.merchant.admin.dto.resp.CouponTemplateQueryRespDTO;
import edu.seu.couponhub.merchant.admin.service.CouponTemplateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

    @Operation(summary = "商家创建优惠券模板")
    @NoDuplicateSubmit(message = "请勿短时间内重复提交优惠券模板")
    @PostMapping("/api/merchant-admin/coupon-template/create")
    public Result<String> createCouponTemplate(@RequestBody CouponTemplateSaveReqDTO requestParam) {
        return Results.success(couponTemplateService.createCouponTemplate(requestParam));
    }

    @Operation(summary = "分页查询优惠券模板")
    @GetMapping("/api/merchant-admin/coupon-template/page")
    public Result<IPage<CouponTemplatePageQueryRespDTO>> pageQueryCouponTemplate(CouponTemplatePageQueryReqDTO requestParam) {
        return Results.success(couponTemplateService.pageQueryCouponTemplate(requestParam));
    }

    @Operation(summary = "查询优惠券模板详情")
    @GetMapping("/api/merchant-admin/coupon-template/find")
    public Result<CouponTemplateQueryRespDTO> findCouponTemplate(String couponTemplateId) {
        return Results.success(couponTemplateService.findCouponTemplateById(couponTemplateId));
    }

    @Operation(summary = "远程查询优惠券模板详情")
    @GetMapping("/api/merchant-admin/coupon-template/remote/query")
    public Result<edu.seu.couponhub.api.dto.resp.CouponTemplateQueryRespDTO> remoteFindCouponTemplate(String shopNumber, String couponTemplateId) {
        CouponTemplateQueryRespDTO result = couponTemplateService.findCouponTemplateByShopNumberAndId(shopNumber, couponTemplateId);
        return Results.success(BeanUtil.toBean(result, edu.seu.couponhub.api.dto.resp.CouponTemplateQueryRespDTO.class));
    }

    @Operation(summary = "增加优惠券模板发行量")
    @NoDuplicateSubmit(message = "请勿短时间内重复增加优惠券发行量")
    @PostMapping("/api/merchant-admin/coupon-template/increase-number")
    public Result<Void> increaseNumberCouponTemplate(@RequestBody CouponTemplateNumberReqDTO requestParam) {
        couponTemplateService.increaseNumberCouponTemplate(requestParam);
        return Results.success();
    }

    @Operation(summary = "远程扣减优惠券模板库存")
    @PostMapping("/api/merchant-admin/coupon-template/remote/decrement-stock")
    public Result<Void> remoteDecrementCouponTemplateStock(@RequestBody CouponTemplateStockDecrementReqDTO requestParam) {
        couponTemplateService.decrementCouponTemplateStock(requestParam);
        return Results.success();
    }

    @Operation(summary = "结束优惠券模板")
    @PostMapping("/api/merchant-admin/coupon-template/terminate")
    public Result<Void> terminateCouponTemplate(String couponTemplateId) {
        couponTemplateService.terminateCouponTemplate(couponTemplateId);
        return Results.success();
    }
}
