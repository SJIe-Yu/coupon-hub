package edu.seu.couponhub.search.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import edu.seu.couponhub.framework.result.Result;
import edu.seu.couponhub.framework.web.Results;
import edu.seu.couponhub.search.dto.req.CouponTemplatePageQueryReqDTO;
import edu.seu.couponhub.search.dto.resp.CouponTemplatePageQueryRespDTO;
import edu.seu.couponhub.search.service.CouponTemplateSearchService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 优惠券模板搜索控制层
 * <p>
 */
@RestController
@RequiredArgsConstructor
@Tag(name = "优惠券模板搜索管理")
public class CouponTemplateController {

    private final CouponTemplateSearchService couponTemplateSearchService;

    @Operation(summary = "分页查询优惠券模板")
    @GetMapping("/api/search/coupon-template/page")
    public Result<IPage<CouponTemplatePageQueryRespDTO>> pageQueryCouponTemplate(CouponTemplatePageQueryReqDTO requestParam) {
        return Results.success(couponTemplateSearchService.pageQueryCouponTemplate(requestParam));
    }
}
