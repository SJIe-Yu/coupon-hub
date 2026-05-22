# 数据库初始化脚本

数据库迁移由 Flyway 通过 `database-migration` 模块管理。
SQL 迁移文件位置：`database-migration/src/main/resources/db/migration/{service}/`

## 服务库归属

- `merchant-admin`: `coupon_hub_merchant_0`、`coupon_hub_merchant_1`
- `engine`: `coupon_hub_engine_0`、`coupon_hub_engine_1`
- `settlement`: `coupon_hub_settlement_0`、`coupon_hub_settlement_1`
- `search`: 不直接维护 MySQL 业务库
- `gateway`: 不维护业务数据库

## 迁移方法

### 本地开发（需要 Docker MySQL）

```bash
./mvnw -pl database-migration -P migrate process-resources flyway:migrate \
  -Ddb.host=localhost -Ddb.port=3306 \
  -Ddb.user=root -Ddb.password=your_password
```

### CI (Testcontainers)

集成测试 `DatabaseMigrationIT.java` 使用 Testcontainers 自动管理 MySQL 实例，验证迁移脚本正确性。

```bash
./mvnw -pl database-migration -am -P it verify
```

### K3s 生产环境

由 CD Pipeline 自动执行 `mvn -pl database-migration -P migrate` 连接 k3s MySQL。

## 维护约定

- 新增迁移脚本：在 `database-migration/src/main/resources/db/migration/{service}/` 下创建 `V{version}__description.sql`
- 服务只能直接访问自己目录下脚本创建的数据库表
- 跨服务读写必须通过 OpenFeign、RocketMQ 事件或 Canal 同步读模型完成
