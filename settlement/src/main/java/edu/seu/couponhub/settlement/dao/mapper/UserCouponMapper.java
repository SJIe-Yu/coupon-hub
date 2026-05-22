package edu.seu.couponhub.settlement.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import edu.seu.couponhub.settlement.dao.entity.UserCouponDO;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户优惠券数据库持久层
 * <p>
 */
@Mapper
public interface UserCouponMapper extends BaseMapper<UserCouponDO> {
}
