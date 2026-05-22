package edu.seu.couponhub.api.dto.req;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 优惠券模板库存扣减请求参数
 * <p>
 */
@Data
@Schema(description = "优惠券模板库存扣减请求参数")
public class CouponTemplateStockDecrementReqDTO {

    /**
     * 店铺编号
     */
    @Schema(description = "店铺编号", required = true)
    private Long shopNumber;

    /**
     * 优惠券模板 ID
     */
    @Schema(description = "优惠券模板 ID", required = true)
    private Long couponTemplateId;

    /**
     * 扣减库存数量
     */
    @Schema(description = "扣减库存数量", required = true)
    private Long decrementStock;
}
