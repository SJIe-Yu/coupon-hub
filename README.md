# Coupon Hub

`coupon-hub` 是优惠券管理系统的工程名，当前工程按微服务模块拆分：

- `coupon-hub-gateway`：网关服务
- `coupon-hub-merchant-admin`：商家后台和批量发券能力
- `coupon-hub-engine`：优惠券查询、领取、锁定、核销等核心能力
- `coupon-hub-settlement`：订单结算场景的优惠券计算能力
- `coupon-hub-search`：优惠券搜索能力
- `coupon-hub-api`：服务间调用契约
- `coupon-hub-framework`：通用基础设施

开发环境的 Nacos 配置模板位于 `resources/nacos/dev`，数据库初始化脚本位于 `resources/database`。
