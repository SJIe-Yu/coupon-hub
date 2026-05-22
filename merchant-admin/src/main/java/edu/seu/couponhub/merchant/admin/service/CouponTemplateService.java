package edu.seu.couponhub.merchant.admin.service;

import edu.seu.couponhub.api.dto.req.CouponTemplateStockDecrementReqDTO;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import edu.seu.couponhub.merchant.admin.dao.entity.CouponTemplateDO;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateNumberReqDTO;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplatePageQueryReqDTO;
import edu.seu.couponhub.merchant.admin.dto.req.CouponTemplateSaveReqDTO;
import edu.seu.couponhub.merchant.admin.dto.resp.CouponTemplatePageQueryRespDTO;
import edu.seu.couponhub.merchant.admin.dto.resp.CouponTemplateQueryRespDTO;

/**
 * 优惠券模板业务逻辑层
 * <p>
 */
public interface CouponTemplateService extends IService<CouponTemplateDO> {

    /**
     * 创建商家优惠券模板
     *
     * @param requestParam 请求参数
     * @return 优惠券模板 ID
     */
    String createCouponTemplate(CouponTemplateSaveReqDTO requestParam);

    /**
     * 分页查询商家优惠券模板
     *
     * @param requestParam 请求参数
     * @return 商家优惠券模板分页数据
     */
    IPage<CouponTemplatePageQueryRespDTO> pageQueryCouponTemplate(CouponTemplatePageQueryReqDTO requestParam);

    /**
     * 查询优惠券模板详情
     * 后管接口并不存在并发，直接查询数据库即可
     *
     * @param couponTemplateId 优惠券模板 ID
     * @return 优惠券模板详情
     */
    CouponTemplateQueryRespDTO findCouponTemplateById(String couponTemplateId);

    /**
     * 按店铺编号和模板 ID 查询优惠券模板。
     * 供其他服务通过 OpenFeign 调用，不依赖商家后台登录上下文。
     *
     * @param shopNumber       店铺编号
     * @param couponTemplateId 优惠券模板 ID
     * @return 优惠券模板详情
     */
    CouponTemplateQueryRespDTO findCouponTemplateByShopNumberAndId(String shopNumber, String couponTemplateId);

    /**
     * 结束优惠券模板
     *
     * @param couponTemplateId 优惠券模板 ID
     */
    void terminateCouponTemplate(String couponTemplateId);

    /**
     * 增加优惠券模板发行量
     *
     * @param requestParam 请求参数
     */
    void increaseNumberCouponTemplate(CouponTemplateNumberReqDTO requestParam);

    /**
     * 扣减优惠券模板库存。
     *
     * @param requestParam 请求参数
     */
    void decrementCouponTemplateStock(CouponTemplateStockDecrementReqDTO requestParam);
}
