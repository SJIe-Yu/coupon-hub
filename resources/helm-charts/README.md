# k3s 基础设施 Helm Charts

这些 Helm chart 放在 Multipass 的 `k3s` 节点上，用于部署学习环境里的基础设施组件。

## 目录

```text
~/helm-charts/
  mysql/      # 只部署开发环境
  redis/      # 部署开发环境
  nacos/      # 部署开发环境
  rocketmq/   # 部署开发环境
  xxl-job/    # 部署开发环境
  canal/      # 部署开发环境
```

## 命名空间约定

```text
开发环境: infra-dev
```

## 当前部署状态

当前已部署的开发环境 release：

```bash
helm list -n infra-dev
```

```text
mysql-dev
redis-dev
nacos-dev
rocketmq-dev
xxl-job-dev
canal-dev
```

## 镜像版本

当前 dev 环境实际部署的镜像：

```text
mysql:8.0
redis:7.2-alpine
nacos/nacos-server:v2.3.2-slim
apache/rocketmq:5.3.1
apacherocketmq/rocketmq-dashboard:latest
wangpenghua/xxl-job-admin:2.4.1
canal/canal-server:v1.1.8-arm64
```

对应组件：

```text
MySQL: mysql:8.0
Redis: redis:7.2-alpine
Nacos: nacos/nacos-server:v2.3.2-slim
RocketMQ nameserver: apache/rocketmq:5.3.1
RocketMQ broker: apache/rocketmq:5.3.1
RocketMQ Dashboard: apacherocketmq/rocketmq-dashboard:latest
XXL-Job Admin: wangpenghua/xxl-job-admin:2.4.1
Canal Server: canal/canal-server:v1.1.8-arm64
```

Canal 依赖 MySQL binlog。开发 MySQL 和外部生产 MySQL 都需要开启：

```text
server-id
log-bin
binlog-format = ROW
binlog-row-image = FULL
```

## 安装开发环境

开发环境先安装 MySQL，再安装依赖 MySQL 的 Nacos。

```bash
helm upgrade --install mysql-dev ~/helm-charts/mysql \
  --namespace infra-dev \
  --create-namespace

helm upgrade --install rocketmq-dev ~/helm-charts/rocketmq \
  -f ~/helm-charts/rocketmq/values-dev.yaml \
  --namespace infra-dev \
  --create-namespace

helm upgrade --install redis-dev ~/helm-charts/redis \
  -f ~/helm-charts/redis/values-dev.yaml \
  --namespace infra-dev \
  --create-namespace

helm upgrade --install nacos-dev ~/helm-charts/nacos \
  -f ~/helm-charts/nacos/values-dev.yaml \
  --namespace infra-dev \
  --create-namespace

helm upgrade --install xxl-job-dev ~/helm-charts/xxl-job \
  -f ~/helm-charts/xxl-job/values-dev.yaml \
  --namespace infra-dev \
  --create-namespace

helm upgrade --install canal-dev ~/helm-charts/canal \
  -f ~/helm-charts/canal/values-dev.yaml \
  --namespace infra-dev \
  --create-namespace
```

开发环境的 Nacos 连接 k8s 内部 MySQL：

```text
mysql-dev-mysql.infra-dev.svc.cluster.local:3306
```

## 验证

查看 Helm release：

```bash
helm list -n infra-dev
```

查看 Pod：

```bash
kubectl get pods -n infra-dev -o wide
```

查看 Service：

```bash
kubectl get svc -n infra-dev
```

## 宿主机访问地址

当前 dev 环境外部访问建议使用 `worker1` 节点 IP：

```text
worker1: 192.168.252.4
```

原因是当前多个 NodePort 已验证可以通过 `192.168.252.4` 从宿主机访问。

### 开发环境

Nacos 控制台：

```text
http://192.168.252.4:30848/nacos
```

XXL-Job 控制台：

```text
http://192.168.252.4:30090/xxl-job-admin
```

RocketMQ Dashboard：

```text
http://192.168.252.4:30080
```

Canal TCP 端口：

```text
192.168.252.4:30111
```

Canal metrics 端口：

```text
192.168.252.4:30112
```

MySQL 开发环境 NodePort：

```text
192.168.252.4:30306
```

Redis 开发环境 NodePort：

```text
192.168.252.4:30379
```

RocketMQ 开发环境 NodePort：

```text
nameserver: 192.168.252.4:30987
broker fast: 192.168.252.4:30909
broker remoting: 192.168.252.4:30911
broker ha: 192.168.252.4:30912
```

## Spring Boot 开发环境配置

下面配置适用于应用运行在宿主机，直接访问 k3s 暴露出来的 dev 环境 NodePort。

### MySQL

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://192.168.252.4:30306/coupon_hub_merchant_0?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
    username: root
    password: root123456
```

如果连接的是节点上通过 apt 安装的外部 MySQL：

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://192.168.252.3:3306/coupon_hub_merchant_0?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
    username: coupon_hub
    password: "123456"
```

### Redis

```yaml
spring:
  data:
    redis:
      host: 192.168.252.4
      port: 30379
      password: "123456"
```

当前 dev Redis 已启用密码：`123456`。

### Nacos 注册中心和配置中心

Spring Cloud Alibaba 常见配置：

```yaml
spring:
  application:
    name: coupon-hub-merchant-admin
  cloud:
    nacos:
      discovery:
        server-addr: 192.168.252.4:30848
        namespace: public
      config:
        server-addr: 192.168.252.4:30848
        namespace: public
        file-extension: yaml
```

Nacos 控制台：

```text
http://192.168.252.4:30848/nacos
```

默认账号密码通常是：

```text
nacos / nacos
```

### RocketMQ

使用 RocketMQ Spring Boot starter 时，常见配置：

```yaml
rocketmq:
  name-server: 192.168.252.4:30987
  producer:
    group: coupon-hub-producer-group
```

消费者示例：

```yaml
rocketmq:
  name-server: 192.168.252.4:30987
```

Dashboard：

```text
http://192.168.252.4:30080
```

### XXL-Job

应用作为 XXL-Job executor 时，常见配置：

```yaml
xxl:
  job:
    admin:
      addresses: http://192.168.252.4:30090/xxl-job-admin
    accessToken: default_token
    executor:
      appname: coupon-hub-executor
      address:
      ip:
      port: 9999
      logpath: ./logs/xxl-job/jobhandler
      logretentiondays: 30
```

XXL-Job 控制台：

```text
http://192.168.252.4:30090/xxl-job-admin
```

默认登录账号密码通常是：

```text
admin / 123456
```

注意：如果 Spring Boot 应用运行在宿主机，XXL-Job Admin 要回调 executor，`executor.ip` 需要填写宿主机对 k3s 可访问的 IP，或者让 executor 主动注册时使用可达地址。

### Canal

Canal 本身不是 Spring Boot 的通用 HTTP 服务，它暴露的是 TCP 协议端口。Java 应用通常通过 Canal Client 连接：

```text
host: 192.168.252.4
port: 30111
destination: example
username:
password:
```

示例代码通常会使用：

```java
CanalConnector connector = CanalConnectors.newSingleConnector(
    new InetSocketAddress("192.168.252.4", 30111),
    "example",
    "",
    ""
);
```

## 卸载

```bash
helm uninstall nacos-dev -n infra-dev
helm uninstall redis-dev -n infra-dev
helm uninstall rocketmq-dev -n infra-dev
helm uninstall mysql-dev -n infra-dev
helm uninstall xxl-job-dev -n infra-dev
helm uninstall canal-dev -n infra-dev
```

如果需要同时删除命名空间：

```bash
kubectl delete namespace infra-dev
```

## Nacos 数据库初始化

Nacos 使用 MySQL 前，需要在 `nacos_config` 数据库中导入和 Nacos 版本匹配的 MySQL 表结构。

开发环境 MySQL 地址：

```text
mysql-dev-mysql.infra-dev.svc.cluster.local
```

## XXL-Job 数据库初始化

XXL-Job 使用 MySQL 前，需要导入对应版本的 `tables_xxl_job.sql`。

当前已经按 XXL-Job `2.4.1` 初始化：

```text
开发环境数据库: xxl_job
数据库用户: xxl_job
数据库密码: xxl_job123456
```

## Canal 配置

当前 Canal 使用 `canal/canal-server:v1.1.8-arm64`。

当前已部署：

```text
canal-dev  -> 监听 mysql-dev-mysql.infra-dev.svc.cluster.local:3306
```

Canal 账号：

```text
username: canal
password: canal123456
```

默认订阅规则：

```text
coupon_hub_.*\..*
```

也就是只订阅 `coupon_hub_*` 库的所有表。可以在以下文件中调整：

```text
~/helm-charts/canal/values-dev.yaml
```
