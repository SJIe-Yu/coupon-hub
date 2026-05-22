package edu.seu.couponhub.settlement.service;

import edu.seu.couponhub.settlement.dto.req.QueryCouponsReqDTO;
import edu.seu.couponhub.settlement.dto.resp.QueryCouponsRespDTO;

/**
 * 查询用户可用优惠券列表接口
 * <p>
 */
public interface CouponQueryService {

    /**
     * 查询用户可用/不可用的优惠券列表，返回 CouponsRespDTO 对象
     *
     * @param requestParam 查询参数
     * @return 包含可用/不可用优惠券的查询结果
     */
    QueryCouponsRespDTO listQueryUserCoupons(QueryCouponsReqDTO requestParam);

    /**
     * 查询用户可用/不可用的优惠券列表，返回 CouponsRespDTO 对象
     *
     * @param requestParam 查询参数
     * @return 包含可用/不可用优惠券的查询结果
     */
    QueryCouponsRespDTO listQueryUserCouponsBySync(QueryCouponsReqDTO requestParam);
}

