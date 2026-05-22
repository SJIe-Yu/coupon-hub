package edu.seu.couponhub.engine.mq.event;

import edu.seu.couponhub.engine.dto.req.CouponTemplateRedeemReqDTO;
import edu.seu.couponhub.engine.dto.resp.CouponTemplateQueryRespDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 用户兑换优惠券事件
 * <p>
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserCouponRedeemEvent {

    /**
     * Web 请求参数
     */
    private CouponTemplateRedeemReqDTO requestParam;

    /**
     * 领取次数
     */
    private Integer receiveCount;

    /**
     * 优惠券模板
     */
    private CouponTemplateQueryRespDTO couponTemplate;

    /**
     * 用户 ID
     */
    private String userId;
}
