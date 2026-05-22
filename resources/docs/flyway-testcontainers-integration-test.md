# Flyway 与 Testcontainers 集成测试说明

本文记录当前项目如何用 Flyway 管理数据库初始化，并用 Testcontainers 在 CI 中验证 SQL 脚本。

## 目标

- SQL 脚本仍统一维护在 `resources/database`。
- 每个服务拥有独立数据库，服务内部继续保留分库分表。
- CI 不依赖本机或 k3s 中的 MySQL，而是通过 `mysql:8.0` Testcontainers 临时启动数据库。
- Flyway 负责记录迁移历史，避免同一套脚本在目标环境重复执行。

## 模块

数据库迁移能力放在独立模块：

```text
database-migration/
```

该模块包含：

- Flyway 迁移入口：`edu.seu.couponhub.database.migration.DatabaseMigrationApplication`
- 服务迁移定义：`merchant-admin`、`engine`、`settlement`
- Java-based Flyway migrations：按服务目录读取现有 SQL 文件
- 集成测试：启动 `mysql:8.0`，执行全部迁移，并校验关键库表

## 执行集成测试

本地执行：

```bash
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home \
./mvnw -pl database-migration -am -P it verify
```

CI 中执行：

```bash
./mvnw -pl database-migration -am -P it verify
```

`-P it` 会启用 Maven Failsafe，只运行 `*IT.java` 集成测试。

## 执行真实环境迁移

部署到 k3s 前，通过迁移模块连接目标 MySQL：

```bash
java -jar database-migration/target/coupon-hub-database-migration-0.0.1-SNAPSHOT.jar \
  --couponhub.migration.services=all \
  --couponhub.migration.jdbc-url=jdbc:mysql://192.168.252.4:30306/ \
  --couponhub.migration.username=root \
  --couponhub.migration.password=root123456 \
  --couponhub.migration.database-root="${PWD}/resources/database"
```

也可以只迁移部分服务：

```bash
--couponhub.migration.services=merchant-admin,engine
```

## Flyway 历史库

每个服务使用独立的 Flyway history schema：

```text
coupon_hub_merchant_flyway_history
coupon_hub_engine_flyway_history
coupon_hub_settlement_flyway_history
```

业务库仍是服务自己的分片库：

```text
coupon_hub_merchant_0 / coupon_hub_merchant_1
coupon_hub_engine_0 / coupon_hub_engine_1
coupon_hub_settlement_0 / coupon_hub_settlement_1
```

## 泛化到其他项目

通用做法：

1. 把数据库脚本按服务或 bounded context 拆目录。
2. 新建独立 migration 模块，不依赖业务服务启动。
3. 每个服务一组 Flyway migration，分别记录迁移历史。
4. CI 使用 Testcontainers 启动与目标环境同版本的数据库镜像。
5. CD 在部署应用前先执行迁移，迁移成功后再滚动发布服务。

这个模式适合 monorepo 微服务项目，也适合后续把每个服务拆成独立仓库。
