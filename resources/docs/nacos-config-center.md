# Nacos 配置中心拆分说明

本文记录开发环境如何把公共配置放到 Nacos 配置中心统一管理。

## 命名空间

开发环境统一使用：

```text
coupon-hub-dev
```

注意：Nacos 的 `namespace` 配置项实际使用的是命名空间 ID。如果你的 Nacos 控制台创建命名空间时 ID 不是 `coupon-hub-dev`，需要启动时覆盖：

```bash
NACOS_NAMESPACE=<实际 namespace id>
```

## 本地配置保留什么

各服务的 `application-dev.yaml` 只保留启动时必须知道的信息：

- `server.port`
- `spring.application.name`
- `spring.cloud.nacos.discovery/config.server-addr`
- `spring.cloud.nacos.discovery/config.namespace`
- 当前服务本地资源配置，例如 ShardingSphere datasource
- `spring.config.import` 中声明要从 Nacos 拉取哪些 DataId

Nacos 地址和 namespace 不能完全放到 Nacos 配置中心里，因为应用必须先知道“去哪里拉配置”。

## DataId 拆分

公共配置不要塞到一个大 yaml，当前按能力拆分为：

```text
coupon-hub-redis-dev.yaml
coupon-hub-rocketmq-dev.yaml
coupon-hub-springdoc-dev.yaml
coupon-hub-knife4j-dev.yaml
coupon-hub-xxl-job-dev.yaml
coupon-hub-elasticsearch-dev.yaml
```

服务私有配置按服务拆分：

```text
coupon-hub-merchant-admin-dev.yaml
coupon-hub-engine-dev.yaml
coupon-hub-search-dev.yaml
coupon-hub-settlement-dev.yaml
coupon-hub-gateway-dev.yaml
```

这些模板保存在：

```text
resources/nacos/dev/
```

在 Nacos 控制台中创建对应 DataId 时，统一使用：

```text
Group: COUPON_HUB_GROUP
Format: YAML
Namespace: coupon-hub-dev
```

## 服务引用方式

服务通过 `spring.config.import` 精确引用自己需要的公共配置。例如 `merchant-admin` 引用：

```yaml
spring:
  config:
    import:
      - optional:nacos:coupon-hub-redis-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
      - optional:nacos:coupon-hub-rocketmq-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
      - optional:nacos:coupon-hub-springdoc-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
      - optional:nacos:coupon-hub-knife4j-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
      - optional:nacos:coupon-hub-xxl-job-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
      - optional:nacos:coupon-hub-merchant-admin-dev.yaml?group=COUPON_HUB_GROUP&refreshEnabled=true
```

`optional:nacos:` 表示本地编译或临时未创建 DataId 时不会直接启动失败；真正联调时仍应在 Nacos 中创建完整配置。
