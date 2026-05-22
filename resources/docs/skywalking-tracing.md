# SkyWalking 全链路日志追踪方案

本文记录 coupon-hub 在本地 Multipass/k3s 环境中接入 SkyWalking 的方案。目标是打通服务调用链路、日志 TraceId 关联、服务拓扑和基础性能观测。

## 一、总体架构

当前项目包含以下业务服务：

```text
gateway
merchant-admin
engine
settlement
search
```

业务服务通过 Spring Cloud Gateway、OpenFeign、Nacos、RocketMQ、Redis、MySQL、Elasticsearch 等组件协作。SkyWalking 接入后，链路结构如下：

```text
gateway
  -> merchant-admin
  -> engine
  -> settlement
  -> search

business pods
  -> SkyWalking Java Agent
  -> skywalking-oap:11800
  -> Elasticsearch
  -> skywalking-ui
```

推荐部署到独立命名空间：

```text
observability
```

核心组件：

- `skywalking-oap`：接收 agent 上报的 trace、metrics、logs。
- `skywalking-ui`：查询链路、拓扑、日志和指标。
- `elasticsearch`：作为 SkyWalking 存储后端。

内网访问建议：

```text
SkyWalking UI NodePort: 30092
OAP gRPC: skywalking-oap.observability.svc.cluster.local:11800
```

## 二、Multipass worker 节点磁盘扩容

SkyWalking + Elasticsearch 会显著增加镜像和持久化数据占用。当前 worker 节点磁盘偏小，部署前建议将 `worker1`、`worker2` 扩容到 `20G`。

查看当前磁盘：

```bash
multipass exec worker1 -- df -h
multipass exec worker2 -- df -h
```

停止 worker：

```bash
multipass stop worker1 worker2
```

调整磁盘大小：

```bash
multipass set local.worker1.disk=20G
multipass set local.worker2.disk=20G
```

启动 worker：

```bash
multipass start worker1 worker2
```

确认文件系统是否自动扩容：

```bash
multipass exec worker1 -- df -h
multipass exec worker2 -- df -h
```

如果根分区仍未显示约 `20G`，进入节点执行文件系统扩容：

```bash
multipass exec worker1 -- sudo growpart /dev/sda 1
multipass exec worker1 -- sudo resize2fs /dev/sda1

multipass exec worker2 -- sudo growpart /dev/sda 1
multipass exec worker2 -- sudo resize2fs /dev/sda1
```

扩容后确认 k3s 节点恢复：

```bash
multipass exec k3s -- sudo k3s kubectl get nodes -o wide
```

## 三、SkyWalking 后端部署

使用 SkyWalking 官方 Helm chart，存储选择 Elasticsearch。

建议版本：

```text
SkyWalking Helm chart: 4.9.0
SkyWalking OAP: 10.4.0
SkyWalking UI: horizon-1.0.0
Elasticsearch: 7.x 或 8.x，按 chart 支持版本选择
```

添加 Helm 仓库：

```bash
helm repo add skywalking https://apache.jfrog.io/artifactory/skywalking-helm
helm repo update
```

创建命名空间：

```bash
kubectl create namespace observability
```

开发环境建议使用单节点 Elasticsearch，资源配置保持克制：

```yaml
oap:
  storageType: elasticsearch
  replicas: 1
  env:
    SW_STORAGE_ES_CLUSTER_NODES: elasticsearch-master.observability.svc.cluster.local:9200

ui:
  replicas: 1
  service:
    type: NodePort
    nodePort: 30092

elasticsearch:
  enabled: true
  replicas: 1
  minimumMasterNodes: 1
  esJavaOpts: "-Xms512m -Xmx512m"
  volumeClaimTemplate:
    resources:
      requests:
        storage: 8Gi
```

部署命令示例：

```bash
helm upgrade --install skywalking skywalking/skywalking \
  --namespace observability \
  --create-namespace \
  -f resources/helm-charts/skywalking/values-dev.yaml
```

如果不希望把 SkyWalking chart 放入仓库，也可以先用临时 values 文件验证，验证通过后再纳入 `resources/helm-charts` 管理。

验证组件状态：

```bash
kubectl get pods,svc -n observability -o wide
```

访问 UI：

```text
http://<k3s-node-ip>:30092
```

## 四、业务服务接入 Java Agent

业务服务不需要改业务代码，优先通过 Helm chart 注入 Java Agent。

推荐在 `coupon-hub-app` chart 中增加 SkyWalking 配置：

```yaml
skywalking:
  enabled: true
  agentImage: apache/skywalking-java-agent:9.6.0-java17
  oapAddress: skywalking-oap.observability.svc.cluster.local:11800
  serviceName: ""
  gatewayPlugin:
    enabled: false
```

服务级 values 设置：

```yaml
skywalking:
  enabled: true
  serviceName: coupon-hub::merchant-admin
```

gateway 需要额外启用 Spring Cloud Gateway optional plugin：

```yaml
skywalking:
  enabled: true
  serviceName: coupon-hub::gateway
  gatewayPlugin:
    enabled: true
```

推荐服务名：

```text
coupon-hub::gateway
coupon-hub::merchant-admin
coupon-hub::engine
coupon-hub::settlement
coupon-hub::search
```

Helm 注入方式：

1. 使用 initContainer 从 `apache/skywalking-java-agent:9.6.0-java17` 拷贝 agent 到 `emptyDir`。
2. 主容器挂载 `/skywalking/agent`。
3. 主容器增加 `JAVA_TOOL_OPTIONS` 和 `SW_AGENT_*` 环境变量。

关键环境变量：

```text
JAVA_TOOL_OPTIONS=-javaagent:/skywalking/agent/skywalking-agent.jar
SW_AGENT_NAME=coupon-hub::<service>
SW_AGENT_COLLECTOR_BACKEND_SERVICES=skywalking-oap.observability.svc.cluster.local:11800
SW_AGENT_INSTANCE_NAME=$(HOSTNAME)
```

gateway optional plugin 处理：

```bash
cp /skywalking/agent/optional-plugins/apm-spring-cloud-gateway-3.x-plugin-*.jar \
  /skywalking/agent/plugins/
```

注意：optional plugin 只给 gateway 开启，其他服务不需要启用，避免额外采集开销。

## 五、日志 TraceId 关联

当前 gateway 已有 `logback-spring.xml`，日志格式中使用了 MDC 的 `traceId`。接入 SkyWalking 后建议统一改为 SkyWalking toolkit 的 `%tid`，这样不依赖业务手动写 MDC。

父 POM 增加版本管理：

```xml
<skywalking.version>9.6.0</skywalking.version>
```

各服务引入 Logback toolkit：

```xml
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-logback-1.x</artifactId>
    <version>${skywalking.version}</version>
</dependency>
```

统一日志格式：

```xml
<Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level [%thread] [%logger{50}:%line] [traceId=%tid] %msg%n</Pattern>
```

如果需要日志直接进入 SkyWalking Logs 页面，增加 gRPC appender：

```xml
<appender name="GRPC_LOG" class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.log.GRPCLogClientAppender">
    <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
        <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level [%thread] [%logger{50}:%line] [traceId=%tid] %msg%n</Pattern>
        </layout>
    </encoder>
</appender>
```

同时保留 stdout：

```xml
<root level="INFO">
    <appender-ref ref="STDOUT"/>
    <appender-ref ref="GRPC_LOG"/>
</root>
```

MyBatis 日志建议从 stdout 改为 slf4j，避免 SQL 日志绕过统一日志格式：

```yaml
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.slf4j.Slf4jImpl
```

## 六、CD 集成建议

SkyWalking 后端应该先于业务服务部署。

建议顺序：

1. 扩容 worker 节点磁盘。
2. 部署 Elasticsearch、OAP、UI。
3. 确认 OAP `11800` 可访问。
4. 更新 `coupon-hub-app` chart，开启 SkyWalking agent 注入。
5. 全量执行 CI/CD。
6. 通过 UI 验证拓扑、trace 和日志。

当前本地 k3s 拉 GHCR 镜像较慢，`kubectl rollout status` 的超时时间建议从 `180s` 提高到 `600s`。否则首次拉业务镜像或 SkyWalking 镜像时，CD 容易因为超时失败。

## 七、验证清单

基础组件：

```bash
kubectl get pods -n observability
kubectl get svc -n observability
```

业务服务：

```bash
kubectl get pods,deploy -n coupon-hub-dev -o wide
kubectl describe pod <pod-name> -n coupon-hub-dev
```

确认 agent 参数：

```bash
kubectl exec -n coupon-hub-dev <pod-name> -- printenv | grep -E 'JAVA_TOOL_OPTIONS|SW_AGENT'
```

链路验证：

1. 从浏览器或 curl 访问 gateway。
2. 触发一次会调用后端服务的业务接口。
3. 在 SkyWalking UI 查看 Service、Topology、Trace。
4. 确认调用链中出现 gateway 和对应后端服务。

日志验证：

```bash
kubectl logs -n coupon-hub-dev <pod-name> | grep traceId
```

在 SkyWalking UI 中：

1. 打开 Logs。
2. 按 service 过滤。
3. 使用日志中的 `traceId` 查询。
4. 从 Trace 页面确认同一 traceId 能关联日志。

## 八、风险与约束

- Elasticsearch 会占用较多磁盘和内存，本地开发环境必须控制副本数、堆大小和 PVC 大小。
- worker 节点如果仍是 8G 左右磁盘，部署 SkyWalking 后很容易因为镜像和 ES 数据导致磁盘不足。
- 首次拉取 SkyWalking、Elasticsearch、业务服务镜像会较慢，CD rollout timeout 需要放宽。
- gateway 使用 Spring Cloud Gateway，需要额外启用 optional plugin，否则 gateway 链路可能不完整。
- 日志上报到 SkyWalking 会增加 OAP 和 ES 压力，开发环境建议 INFO 起步，避免 DEBUG 全量上报。

