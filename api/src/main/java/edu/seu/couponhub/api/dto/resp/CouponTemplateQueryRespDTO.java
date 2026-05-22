package edu.seu.couponhub.api.dto.resp;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;

/**
 * 优惠券模板查询远程返回参数
 * <p>
 */
@Data
@Schema(description = "优惠券模板查询远程返回参数")
public class CouponTemplateQueryRespDTO {

    @Schema(description = "优惠券 ID")
    private String id;

    @Schema(description = "优惠券名称")
    private String name;

    @Schema(description = "店铺编号")
    private String shopNumber;

    @Schema(description = "优惠券来源 0：店铺券 1：平台券")
    private Integer source;

    @Schema(description = "优惠对象 0：商品专属 1：全店通用")
    private Integer target;

    @Schema(description = "优惠商品编码")
    private String goods;

    @Schema(description = "优惠类型 0：立减券 1：满减券 2：折扣券")
    private Integer type;

    @Schema(description = "有效期开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date validStartTime;

    @Schema(description = "有效期结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date validEndTime;

    @Schema(description = "库存")
    private Integer stock;

    @Schema(description = "领取规则")
    private String receiveRule;

    @Schema(description = "消耗规则")
    private String consumeRule;

    @Schema(description = "优惠券状态 0：生效中 1：已结束")
    private Integer status;
}
