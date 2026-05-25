# SkyWalking 全链路日志追踪方案

本文档描述 coupon-hub 项目引入 Apache SkyWalking 实现全链路追踪的完整方案。
SkyWalking 部署在本地 Multipass k3s 集群，数据存储使用独立的 Elasticsearch。

## 整体架构

```text
┌──────────────────────────────────────────────────────────────────────┐
│  k3s 集群 (Multipass)                                                │
│                                                                      │
│  ┌─────────────────────── infra-dev ───────────────────────────────┐ │
│  │                                                                 │ │
│  │  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐   │ │
│  │  │ Elasticsearch│◄───│ SkyWalking   │    │  SkyWalking UI   │   │ │
│  │  │   (单节点)   │    │   OAP Server │◄───│  (NodePort:31280)│   │ │
│  │  │ NodePort:31200│    │              │    │                  │   │ │
│  │  └─────────────┘    └──────┬───────┘    └──────────────────┘   │ │
│  │                            │ gRPC:11800                         │ │
│  │                            │ REST:12800                         │ │
│  └────────────────────────────┼────────────────────────────────────┘ │
│                               │                                      │
│  ┌──────────────── coupon-hub-dev ────────────────────────────────┐  │
│  │                            │                                   │  │
│  │  ┌─────────┐  ┌─────────┐ │ ┌───────────┐  ┌──────────────┐  │  │
│  │  │ gateway │  │ engine  │ │ │ settlement│  │merchant-admin│  │  │
│  │  │ +agent  │  │ +agent  │◄┘ │ +agent    │  │ +agent       │  │  │
│  │  └─────────┘  └─────────┘   └───────────┘  └──────────────┘  │  │
│  │  ┌─────────┐                                                  │  │
│  │  │ search  │                                                  │  │
│  │  │ +agent  │                                                  │  │
│  │  └─────────┘                                                  │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

涉及的业务服务：

| 服务             | 端口  | Spring 应用名                |
| ---------------- | ----- | ----------------------------- |
| gateway          | 10000 | coupon-hub-gateway            |
| merchant-admin   | 10010 | coupon-hub-merchant-admin     |
| engine           | 10020 | coupon-hub-engine             |
| settlement       | 10030 | coupon-hub-settlement         |
| search           | 10050 | coupon-hub-search             |

## 版本选型

| 组件                   | 版本     | 说明                                           |
| ---------------------- | -------- | ---------------------------------------------- |
| Elasticsearch          | 7.17.x   | SkyWalking 9.x/10.x 兼容 ES 7.x，单节点即可   |
| SkyWalking OAP Server  | 10.1.0   | 最新 LTS，支持 JDK 17 agent                    |
| SkyWalking UI          | 10.1.0   | 与 OAP 保持一致                                |
| SkyWalking Java Agent  | 9.3.0    | 最新稳定版，支持 Spring Boot 3.x / JDK 17      |
| SkyWalking Helm Chart  | 4.7.0    | 官方 Helm chart                                |

> 注：JDK 17 + Spring Boot 3.0.7 下，请使用 SkyWalking Java Agent 9.x+。

---

## 第一步：部署 Elasticsearch

在 `infra-dev` 命名空间中部署单节点 Elasticsearch，作为 SkyWalking 的独立存储。

### 1.1 创建 Helm Chart

在 k3s 节点上创建目录：

```bash
mkdir -p ~/helm-charts/elasticsearch
```

创建 `~/helm-charts/elasticsearch/Chart.yaml`：

```yaml
apiVersion: v2
name: elasticsearch
description: Single-node Elasticsearch for SkyWalking
version: 1.0.0
```

创建 `~/helm-charts/elasticsearch/templates/statefulset.yaml`：

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Release.Name }}-es
  labels:
    app: {{ .Release.Name }}-es
spec:
  serviceName: {{ .Release.Name }}-es
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Release.Name }}-es
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-es
    spec:
      containers:
        - name: elasticsearch
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 9200
              name: http
            - containerPort: 9300
              name: transport
          env:
            - name: discovery.type
              value: single-node
            - name: ES_JAVA_OPTS
              value: "{{ .Values.esJavaOpts }}"
            - name: xpack.security.enabled
              value: "false"
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          volumeMounts:
            - name: data
              mountPath: /usr/share/elasticsearch/data
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: {{ .Values.storage.size }}
```

创建 `~/helm-charts/elasticsearch/templates/service.yaml`：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-es
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: 9200
      targetPort: 9200
      name: http
      {{- if eq .Values.service.type "NodePort" }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
    - port: 9300
      targetPort: 9300
      name: transport
  selector:
    app: {{ .Release.Name }}-es
```

创建 `~/helm-charts/elasticsearch/values.yaml`：

```yaml
image:
  repository: docker.elastic.co/elasticsearch/elasticsearch
  tag: "7.17.24"
  pullPolicy: IfNotPresent

esJavaOpts: "-Xms512m -Xmx512m"

resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "1Gi"
    cpu: "1000m"

storage:
  size: 10Gi

service:
  type: NodePort
  nodePort: 31200
```

### 1.2 部署 Elasticsearch

```bash
helm upgrade --install es-dev ~/helm-charts/elasticsearch \
  --namespace infra-dev \
  --create-namespace
```

### 1.3 验证

```bash
kubectl get pods -n infra-dev -l app=es-dev-es
kubectl get svc -n infra-dev es-dev-es

# 从宿主机验证
curl http://192.168.252.4:31200
```

预期返回 Elasticsearch 集群信息 JSON。

---

## 第二步：部署 SkyWalking（OAP + UI）

使用 SkyWalking 官方 Helm Chart 部署 OAP Server 和 UI。

### 2.1 方式一：使用官方 Helm Chart（推荐）

```bash
# 添加 SkyWalking Helm 仓库
helm repo add skywalking https://apache.jfrog.io/artifactory/skywalking-helm
helm repo update
```

创建 `~/helm-charts/skywalking-values.yaml`：

```yaml
oap:
  image:
    repository: apache/skywalking-oap-server
    tag: 10.1.0
    pullPolicy: IfNotPresent
  replicas: 1
  storageType: elasticsearch
  env:
    SW_STORAGE: elasticsearch
    SW_STORAGE_ES_CLUSTER_NODES: es-dev-es.infra-dev.svc.cluster.local:9200
    SW_ES_USER: ""
    SW_ES_PASSWORD: ""
    # 日志相关配置
    SW_RECEIVER_LOG_ENABLED: "true"
    # 调低数据保留天数，节省磁盘
    SW_CORE_RECORD_DATA_TTL: "3"
    SW_CORE_METRICS_DATA_TTL: "7"
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "2Gi"
      cpu: "1000m"
  service:
    type: ClusterIP

ui:
  image:
    repository: apache/skywalking-ui
    tag: 10.1.0
    pullPolicy: IfNotPresent
  replicas: 1
  service:
    type: NodePort
    nodePort: 31280
  resources:
    requests:
      memory: "256Mi"
      cpu: "200m"
    limits:
      memory: "512Mi"
      cpu: "500m"

# 不使用内置 ES，使用外部独立 ES
elasticsearch:
  enabled: false

satellite:
  enabled: false
```

部署：

```bash
helm upgrade --install skywalking-dev skywalking/skywalking \
  -f ~/helm-charts/skywalking-values.yaml \
  --namespace infra-dev \
  --create-namespace
```

### 2.2 方式二：使用自定义 Helm Chart

如果无法访问官方 Helm 仓库，可以自建 chart。

在 k3s 节点上创建目录：

```bash
mkdir -p ~/helm-charts/skywalking/templates
```

创建 `~/helm-charts/skywalking/Chart.yaml`：

```yaml
apiVersion: v2
name: skywalking
description: Apache SkyWalking OAP + UI
version: 1.0.0
```

创建 `~/helm-charts/skywalking/templates/oap-deployment.yaml`：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-oap
  labels:
    app: {{ .Release.Name }}-oap
spec:
  # 本地 k3s 首次拉取镜像和初始化 ES 索引都较慢，避免 Deployment 过早判定失败。
  progressDeadlineSeconds: {{ .Values.oap.progressDeadlineSeconds }}
  replicas: {{ .Values.oap.replicas }}
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: {{ .Release.Name }}-oap
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-oap
    spec:
      containers:
        - name: oap
          image: "{{ .Values.oap.image.repository }}:{{ .Values.oap.image.tag }}"
          imagePullPolicy: {{ .Values.oap.image.pullPolicy }}
          ports:
            - containerPort: 12800
              name: rest
            - containerPort: 11800
              name: grpc
          env:
            - name: SW_STORAGE
              value: elasticsearch
            - name: SW_STORAGE_ES_CLUSTER_NODES
              value: "{{ .Values.oap.esNodes }}"
            - name: SW_RECEIVER_LOG_ENABLED
              value: "true"
            - name: SW_CORE_RECORD_DATA_TTL
              value: "3"
            - name: SW_CORE_METRICS_DATA_TTL
              value: "7"
          resources:
            {{- toYaml .Values.oap.resources | nindent 12 }}
          readinessProbe:
            tcpSocket:
              port: 12800
            initialDelaySeconds: {{ .Values.oap.readinessProbe.initialDelaySeconds }}
            periodSeconds: {{ .Values.oap.readinessProbe.periodSeconds }}
            timeoutSeconds: {{ .Values.oap.readinessProbe.timeoutSeconds }}
            failureThreshold: {{ .Values.oap.readinessProbe.failureThreshold }}
          livenessProbe:
            tcpSocket:
              port: 12800
            initialDelaySeconds: {{ .Values.oap.livenessProbe.initialDelaySeconds }}
            periodSeconds: {{ .Values.oap.livenessProbe.periodSeconds }}
            timeoutSeconds: {{ .Values.oap.livenessProbe.timeoutSeconds }}
            failureThreshold: {{ .Values.oap.livenessProbe.failureThreshold }}
          startupProbe:
            tcpSocket:
              port: 12800
            initialDelaySeconds: {{ .Values.oap.startupProbe.initialDelaySeconds }}
            periodSeconds: {{ .Values.oap.startupProbe.periodSeconds }}
            timeoutSeconds: {{ .Values.oap.startupProbe.timeoutSeconds }}
            failureThreshold: {{ .Values.oap.startupProbe.failureThreshold }}
```

创建 `~/helm-charts/skywalking/templates/oap-service.yaml`：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-oap
spec:
  type: ClusterIP
  ports:
    - port: 12800
      targetPort: 12800
      name: rest
    - port: 11800
      targetPort: 11800
      name: grpc
  selector:
    app: {{ .Release.Name }}-oap
```

创建 `~/helm-charts/skywalking/templates/ui-deployment.yaml`：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-ui
  labels:
    app: {{ .Release.Name }}-ui
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Release.Name }}-ui
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-ui
    spec:
      containers:
        - name: ui
          image: "{{ .Values.ui.image.repository }}:{{ .Values.ui.image.tag }}"
          imagePullPolicy: {{ .Values.ui.image.pullPolicy }}
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: SW_OAP_ADDRESS
              value: "http://{{ .Release.Name }}-oap:12800"
          resources:
            {{- toYaml .Values.ui.resources | nindent 12 }}
```

创建 `~/helm-charts/skywalking/templates/ui-service.yaml`：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-ui
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      name: http
      nodePort: {{ .Values.ui.nodePort }}
  selector:
    app: {{ .Release.Name }}-ui
```

创建 `~/helm-charts/skywalking/values.yaml`：

```yaml
oap:
  replicas: 1
  progressDeadlineSeconds: 1800
  image:
    repository: apache/skywalking-oap-server
    tag: "10.1.0"
    pullPolicy: IfNotPresent
  esNodes: "es-dev-es.infra-dev.svc.cluster.local:9200"
  startupProbe:
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 3
    failureThreshold: 180
  readinessProbe:
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 3
    failureThreshold: 12
  livenessProbe:
    initialDelaySeconds: 60
    periodSeconds: 30
    timeoutSeconds: 3
    failureThreshold: 6
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "2Gi"
      cpu: "1000m"

ui:
  image:
    repository: apache/skywalking-ui
    tag: "10.1.0"
    pullPolicy: IfNotPresent
  nodePort: 31280
  resources:
    requests:
      memory: "256Mi"
      cpu: "200m"
    limits:
      memory: "512Mi"
      cpu: "500m"
```

部署：

```bash
helm upgrade --install skywalking-dev ~/helm-charts/skywalking \
  --namespace infra-dev \
  --create-namespace
```

### 2.3 验证 SkyWalking

```bash
kubectl get pods -n infra-dev -l app=skywalking-dev-oap
kubectl get pods -n infra-dev -l app=skywalking-dev-ui
kubectl get svc -n infra-dev
```

SkyWalking UI 控制台：

```text
http://192.168.252.4:31280
```

---

## 第三步：Java Agent 接入

SkyWalking Java Agent 通过 `-javaagent` 参数以无侵入方式接入，不需要修改业务代码。

### 3.1 业务镜像

业务镜像只打包应用 JAR，不再下载或内置 SkyWalking Java Agent。Agent 由 Kubernetes initContainer 注入。

修改 `Dockerfile.service`：

```dockerfile
ARG SERVICE_MODULE
ARG SERVICE_ARTIFACT

FROM eclipse-temurin:17-jdk AS build
ARG SERVICE_MODULE
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ARG http_proxy
ARG https_proxy
ARG no_proxy
WORKDIR /workspace

# Layer 1: resolve dependencies (cached unless POM files change)
COPY pom.xml ./
COPY .mvn .mvn
COPY mvnw ./
COPY .docker .docker
COPY framework/pom.xml framework/
COPY api/pom.xml api/
COPY database-migration/pom.xml database-migration/
COPY merchant-admin/pom.xml merchant-admin/
COPY engine/pom.xml engine/
COPY settlement/pom.xml settlement/
COPY search/pom.xml search/
COPY gateway/pom.xml gateway/
RUN sh .docker/mvn-with-proxy.sh -pl ${SERVICE_MODULE} -am -DskipTests dependency:go-offline

# Layer 2: build application (source changes only affect this layer)
COPY . .
RUN sh .docker/mvn-with-proxy.sh -pl ${SERVICE_MODULE} -am -DskipTests install
RUN sh .docker/mvn-with-proxy.sh -pl ${SERVICE_MODULE} -DskipTests package org.springframework.boot:spring-boot-maven-plugin:3.0.7:repackage

FROM eclipse-temurin:17-jre
ARG SERVICE_MODULE
ARG SERVICE_ARTIFACT
ENV JAVA_OPTS=""
ENV SPRING_PROFILES_ACTIVE=dev
WORKDIR /app
COPY --from=build /workspace/${SERVICE_MODULE}/target/${SERVICE_ARTIFACT}-0.0.1-SNAPSHOT.jar /app/app.jar
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar /app/app.jar"]
```

> 关键变化：
> 1. 删除 `agent` 构建阶段，业务镜像构建时不再访问 SkyWalking 下载地址。
> 2. 删除最终镜像中的 `skywalking-agent/` 目录，减小业务镜像体积。
> 3. 删除 `ENTRYPOINT` 中硬编码的 `-javaagent`，避免和 Kubernetes 注入方式重复。

### 3.2 Kubernetes InitContainer 注入 Agent

参考 SkyWalking 官方 Kubernetes 容器化方案，使用 `apache/skywalking-java-agent:9.3.0-java17` 作为 initContainer，将 `/skywalking/agent` 复制到 `emptyDir`。业务容器挂载同一 volume，并通过 `JAVA_TOOL_OPTIONS` 自动追加 `-javaagent`。

```yaml
# 在 deployment.yaml 的 spec.template.spec 中添加
initContainers:
  - name: skywalking-agent
    image: apache/skywalking-java-agent:9.3.0-java17
    imagePullPolicy: IfNotPresent
    command: ["/bin/sh"]
    args: ["-c", "cp -R /skywalking/agent /agent/"]
    volumeMounts:
      - name: skywalking-agent
        mountPath: /agent
```

业务容器中挂载同一 volume 并配置 `-javaagent`：

```yaml
containers:
  - name: app
    volumeMounts:
      - name: skywalking-agent
        mountPath: /skywalking
    env:
      - name: JAVA_TOOL_OPTIONS
        value: "-javaagent:/skywalking/agent/skywalking-agent.jar"

volumes:
  - name: skywalking-agent
    emptyDir: {}
```

这种方式的好处是 Agent 镜像由 Kubernetes 节点缓存。业务镜像重新构建时不会重复下载 SkyWalking 发行包，Pod 重启时也只需要复用或拉取一次 `apache/skywalking-java-agent` 镜像。

---

## 第四步：Helm Chart 改造

### 4.1 修改 coupon-hub-app values.yaml

在 `resources/helm-charts/coupon-hub-app/values.yaml` 中增加 SkyWalking Agent 镜像配置和相关环境变量：

```yaml
nameOverride: ""
fullnameOverride: ""

replicaCount: 1

image:
  repository: ghcr.io/owner/coupon-hub-service
  tag: latest
  pullPolicy: IfNotPresent

imagePullSecrets: []

skywalking:
  enabled: true
  image: apache/skywalking-java-agent:9.3.0-java17
  pullPolicy: IfNotPresent
  volumeName: skywalking-agent
  agentPath: /skywalking/agent/skywalking-agent.jar

service:
  type: ClusterIP
  port: 10000
  targetPort: 10000
  nodePort: null

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  # SkyWalking Agent 配置
  SW_AGENT_NAME: coupon-hub-service
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800

resources: {}
```

### 4.2 修改 coupon-hub-app deployment.yaml

在 `resources/helm-charts/coupon-hub-app/templates/deployment.yaml` 中增加 initContainer、volumeMount 和 volume：

```yaml
{{- if .Values.skywalking.enabled }}
initContainers:
  - name: skywalking-agent
    image: {{ .Values.skywalking.image | quote }}
    imagePullPolicy: {{ .Values.skywalking.pullPolicy }}
    command: ["/bin/sh"]
    args: ["-c", "cp -R /skywalking/agent /agent/"]
    volumeMounts:
      - name: {{ .Values.skywalking.volumeName }}
        mountPath: /agent
{{- end }}
```

业务容器中增加：

```yaml
env:
  {{- if and .Values.skywalking.enabled (not (hasKey .Values.env "JAVA_TOOL_OPTIONS")) }}
  - name: JAVA_TOOL_OPTIONS
    value: "-javaagent:{{ .Values.skywalking.agentPath }}"
  {{- end }}
  {{- range $name, $value := .Values.env }}
  - name: {{ $name }}
    value: {{ $value | quote }}
  {{- end }}
{{- if .Values.skywalking.enabled }}
volumeMounts:
  - name: {{ .Values.skywalking.volumeName }}
    mountPath: /skywalking
{{- end }}
```

Pod spec 中增加：

```yaml
{{- if .Values.skywalking.enabled }}
volumes:
  - name: {{ .Values.skywalking.volumeName }}
    emptyDir: {}
{{- end }}
```

### 4.3 修改每个服务的 values 文件

每个服务的 values 文件需要设置对应的 `SW_AGENT_NAME`。

`resources/helm-charts/coupon-hub-app/values/gateway.yaml`：

```yaml
nameOverride: coupon-hub-gateway

service:
  type: NodePort
  port: 10000
  targetPort: 10000
  nodePort: 31000

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev-nacos.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  SW_AGENT_NAME: coupon-hub-gateway
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800
```

`resources/helm-charts/coupon-hub-app/values/merchant-admin.yaml`：

```yaml
nameOverride: coupon-hub-merchant-admin

service:
  type: ClusterIP
  port: 10010
  targetPort: 10010

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev-nacos.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  SW_AGENT_NAME: coupon-hub-merchant-admin
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800
```

`resources/helm-charts/coupon-hub-app/values/engine.yaml`：

```yaml
nameOverride: coupon-hub-engine

service:
  type: ClusterIP
  port: 10020
  targetPort: 10020

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev-nacos.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  SW_AGENT_NAME: coupon-hub-engine
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800
```

`resources/helm-charts/coupon-hub-app/values/settlement.yaml`：

```yaml
nameOverride: coupon-hub-settlement

service:
  type: ClusterIP
  port: 10030
  targetPort: 10030

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev-nacos.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  SW_AGENT_NAME: coupon-hub-settlement
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800
```

`resources/helm-charts/coupon-hub-app/values/search.yaml`：

```yaml
nameOverride: coupon-hub-search

service:
  type: ClusterIP
  port: 10050
  targetPort: 10050

env:
  SPRING_PROFILES_ACTIVE: dev
  NACOS_SERVER_ADDR: nacos-dev-nacos.infra-dev.svc.cluster.local:8848
  NACOS_NAMESPACE: coupon-hub-dev
  SW_AGENT_NAME: coupon-hub-search
  SW_AGENT_COLLECTOR_BACKEND_SERVICES: skywalking-dev-oap.infra-dev.svc.cluster.local:11800
```

---

## 第五步：日志关联 Trace ID

将 SkyWalking Trace ID 注入到日志中，实现日志与链路的关联。

### 5.1 添加 Maven 依赖

在 `framework/pom.xml` 中添加 SkyWalking 日志工具包：

```xml
<!-- SkyWalking Logback 集成：将 Trace ID 注入日志 MDC -->
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-logback-1.x</artifactId>
    <version>9.3.0</version>
</dependency>

<!-- SkyWalking Trace 工具包：支持手动获取 Trace ID 等 -->
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>9.3.0</version>
</dependency>
```

在根 `pom.xml` 的 `<properties>` 中添加版本管理：

```xml
<skywalking-agent.version>9.3.0</skywalking-agent.version>
```

在根 `pom.xml` 的 `<dependencyManagement>` 中添加：

```xml
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-logback-1.x</artifactId>
    <version>${skywalking-agent.version}</version>
</dependency>

<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>${skywalking-agent.version}</version>
</dependency>
```

### 5.2 修改 Logback 配置

以 gateway 的 `logback-spring.xml` 为例，使用 SkyWalking 提供的 `TraceIdPatternLogbackLayout`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
                <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %highlight(%-5level) %blue(%-50logger{50}:%-4line) %thread [traceId=%tid] %msg%n</Pattern>
            </layout>
        </encoder>
    </appender>

    <!-- SkyWalking gRPC 日志上报 Appender -->
    <appender name="SW_GRPC_LOG" class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.log.GRPCLogClientAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.mdc.TraceIdMDCPatternLogbackLayout">
                <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} %-5level %-50logger{50}:%-4line [traceId=%X{tid}] %msg%n</Pattern>
            </layout>
        </encoder>
    </appender>

    <root level="INFO">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="SW_GRPC_LOG" />
    </root>
</configuration>
```

> 关键变化：
> 1. 使用 `TraceIdPatternLogbackLayout` 替代默认 layout。
> 2. 将 `%X{traceId}` 替换为 `%tid`（SkyWalking 专用占位符）。
> 3. 新增 `SW_GRPC_LOG` appender，通过 gRPC 将日志上报到 OAP Server。
> 4. 容器环境不再保留本地 rolling file，仅输出 stdout 并上报 SkyWalking。

### 5.3 在代码中手动获取 Trace ID（可选）

```java
import org.apache.skywalking.apm.toolkit.trace.TraceContext;

// 获取当前 Trace ID
String traceId = TraceContext.traceId();
```

---

## 第六步：SkyWalking Agent 插件配置

SkyWalking Java Agent 自动支持以下项目中使用的组件（无需额外配置）：

| 组件                      | 插件                          | 是否自动生效 |
| ------------------------- | ----------------------------- | ------------ |
| Spring Boot 3.x           | spring-mvc-annotation-6.x     | ✅           |
| Spring Cloud Gateway      | spring-cloud-gateway-4.x      | ✅           |
| OpenFeign                 | feign-default-http             | ✅           |
| MySQL (JDBC)              | jdbc-commons / mysql           | ✅           |
| Redis (Redisson)          | redisson-3.x                  | ✅           |
| RocketMQ                  | rocketmq-4.x / 5.x            | ✅           |
| Elasticsearch             | elasticsearch-7.x              | ✅           |
| ShardingSphere            | shardingsphere-5.x             | ✅           |

### 可选插件

某些可选插件默认未启用，需要手动复制到 `plugins/` 目录：

```bash
# 在 initContainer args 中追加，例如：
cp -R /skywalking/agent /agent/ && \
  cp /agent/agent/optional-plugins/apm-spring-cloud-gateway-3.x-plugin-*.jar \
     /agent/agent/plugins/
```

但对于 Spring Boot 3.x + Spring Cloud Gateway 2022.x，主线版本的 agent 插件应该已经支持，无需手动复制。

### Agent 配置文件

如果需要自定义 Agent 配置，可以在 `skywalking-agent/config/agent.config` 中修改，或通过环境变量覆盖：

```properties
# 采样率，默认全量采集。生产环境可设为如 3000（每3秒最多3000条）
agent.sample_n_per_3_secs=-1

# 忽略的请求路径（如健康检查）
agent.ignore_suffix=.jpg,.jpeg,.js,.css,.png,.bmp,.gif,.ico,.mp3,.mp4,.html,.svg

# 跨线程 trace 传播
agent.is_open_debugging_class=false
```

---

## 第七步：端口分配汇总

更新端口分配表，避免与已有 NodePort 冲突：

| 服务               | 类型     | 端口  | NodePort |
| ------------------ | -------- | ----- | -------- |
| MySQL              | NodePort | 3306  | 30306    |
| Redis              | NodePort | 6379  | 30379    |
| Nacos              | NodePort | 8848  | 30848    |
| RocketMQ nameserver| NodePort | 9876  | 30987    |
| XXL-Job Admin      | NodePort | 8080  | 30090    |
| Canal TCP          | NodePort | 11111 | 30111    |
| **Elasticsearch**  | NodePort | 9200  | **31200**|
| **SkyWalking UI**  | NodePort | 8080  | **31280**|
| gateway (应用)     | NodePort | 10000 | 31000    |

---

## 第八步：完整部署流程

### 8.1 部署顺序

```text
1. Elasticsearch
2. SkyWalking OAP + UI
3. 重新构建业务镜像（不包含 Agent，Agent 由 Helm chart 注入）
4. 部署业务服务
```

### 8.2 一键部署脚本

```bash
#!/bin/bash
set -e

NAMESPACE=infra-dev

echo "=== Step 1: Deploy Elasticsearch ==="
helm upgrade --install es-dev ~/helm-charts/elasticsearch \
  --namespace $NAMESPACE --create-namespace
echo "Waiting for ES to be ready..."
kubectl rollout status statefulset/es-dev-es -n $NAMESPACE --timeout=300s

echo "=== Step 2: Deploy SkyWalking ==="
# 方式一：使用官方 chart
helm upgrade --install skywalking-dev skywalking/skywalking \
  -f ~/helm-charts/skywalking-values.yaml \
  --namespace $NAMESPACE --create-namespace
# 方式二：使用自定义 chart
# helm upgrade --install skywalking-dev ~/helm-charts/skywalking \
#   --namespace $NAMESPACE --create-namespace
echo "Waiting for OAP to be ready..."
kubectl rollout status deployment/skywalking-dev-oap -n $NAMESPACE --timeout=300s

echo "=== Step 3: Verify ==="
echo "Elasticsearch: http://192.168.252.4:31200"
echo "SkyWalking UI: http://192.168.252.4:31280"

echo "=== Done ==="
```

### 8.3 验证链路追踪

1. 打开 SkyWalking UI：`http://192.168.252.4:31280`
2. 发送一个经过 gateway 的请求，例如创建优惠券
3. 在 SkyWalking UI 中：
   - **拓扑图**：查看服务间调用关系（gateway → merchant-admin → MySQL）
   - **追踪**：查看完整调用链，包含每个 span 的耗时
   - **日志**：查看关联了 Trace ID 的日志
   - **服务**：查看各服务的 QPS、响应时间、成功率

---

## 第九步：本地开发环境接入（可选）

本地开发时不部署到 k8s，但也可以接入 SkyWalking：

### 9.1 下载 Agent 到本地

```bash
mkdir -p ~/skywalking
cd ~/skywalking
wget https://archive.apache.org/dist/skywalking/java-agent/9.3.0/apache-skywalking-java-agent-9.3.0.tgz
tar -xzf apache-skywalking-java-agent-9.3.0.tgz
```

### 9.2 IDE 启动参数

在 IntelliJ IDEA 的 VM Options 中添加：

```text
-javaagent:/Users/<username>/skywalking/skywalking-agent/skywalking-agent.jar
-Dskywalking.agent.service_name=coupon-hub-engine
-Dskywalking.collector.backend_service=192.168.252.4:31800
```

> 注：需要将 OAP 的 gRPC 端口 11800 通过 NodePort 暴露，或直接使用 k3s 内网 IP。
> 如果 OAP gRPC 端口未暴露 NodePort，需要添加一个 NodePort Service 或使用 `kubectl port-forward`：
>
> ```bash
> kubectl port-forward svc/skywalking-dev-oap 11800:11800 -n infra-dev
> ```

---

## 第十步：CI/CD 适配

### 10.1 Dockerfile.service 变更

已在第三步描述。更新 `Dockerfile.service` 后，CI/CD pipeline 无需修改构建命令；业务镜像构建阶段不再访问 SkyWalking 下载站。

### 10.2 CD workflow 中的 Helm 命令

现有 CD workflow 中 `helm upgrade --install` 各服务时，values 文件已包含 `SW_AGENT_NAME` 和 `SW_AGENT_COLLECTOR_BACKEND_SERVICES` 环境变量，不需要额外修改命令。

### 10.3 如果需要通过 CD 部署 SkyWalking

可以在 CD workflow 中新增一个 step：

```yaml
- name: Deploy SkyWalking infra
  run: |
    helm upgrade --install es-dev ~/helm-charts/elasticsearch \
      --namespace infra-dev --create-namespace
    kubectl rollout status statefulset/es-dev-es -n infra-dev --timeout=300s

    helm upgrade --install skywalking-dev ~/helm-charts/skywalking \
      --namespace infra-dev --create-namespace
    kubectl rollout status deployment/skywalking-dev-oap -n infra-dev --timeout=300s
```

---

## 故障排查

### Agent 未上报数据

```bash
# 查看应用 Pod 日志，搜索 skywalking 关键字
kubectl logs <pod-name> -n coupon-hub-dev | grep -i skywalking

# 检查 OAP 是否 Ready；SkyWalking 10.1.0 的 12800 端口可用后 TCP 探针会通过
kubectl get pod <oap-pod> -n infra-dev

# 检查 ES 连通性
kubectl exec -it <oap-pod> -n infra-dev -- curl es-dev-es.infra-dev.svc.cluster.local:9200
```

### OAP 启动失败

```bash
# 查看 OAP 日志
kubectl logs -f <oap-pod> -n infra-dev

# 最常见原因：ES 未就绪。确保 ES Pod Running 且通过健康检查后再部署 OAP。
```

### ES 磁盘不足

```bash
# 查看 ES 索引
curl http://192.168.252.4:31200/_cat/indices?v

# 手动清理旧索引
curl -X DELETE http://192.168.252.4:31200/sw_*_20250101
```

---

## 文件变更清单

| 文件                                                            | 操作   | 说明                              |
| --------------------------------------------------------------- | ------ | --------------------------------- |
| `Dockerfile.service`                                            | 修改   | 移除 Agent 下载，业务镜像只保留应用 JAR |
| `pom.xml`                                                       | 修改   | 增加 skywalking toolkit 版本管理  |
| `framework/pom.xml`                                             | 修改   | 增加 logback/trace toolkit 依赖   |
| `gateway/src/main/resources/logback-spring.xml`                 | 修改   | 集成 SkyWalking TraceId 和日志上报|
| `resources/helm-charts/coupon-hub-app/templates/deployment.yaml` | 修改   | 增加 SkyWalking Agent initContainer 注入 |
| `resources/helm-charts/coupon-hub-app/values.yaml`              | 修改   | 增加 Agent 镜像配置和 SW 环境变量默认值 |
| `resources/helm-charts/coupon-hub-app/values/gateway.yaml`      | 修改   | 增加 SW_AGENT_NAME                |
| `resources/helm-charts/coupon-hub-app/values/merchant-admin.yaml`| 修改  | 增加 SW_AGENT_NAME                |
| `resources/helm-charts/coupon-hub-app/values/engine.yaml`       | 修改   | 增加 SW_AGENT_NAME                |
| `resources/helm-charts/coupon-hub-app/values/settlement.yaml`   | 修改   | 增加 SW_AGENT_NAME                |
| `resources/helm-charts/coupon-hub-app/values/search.yaml`       | 修改   | 增加 SW_AGENT_NAME                |
| `resources/helm-charts/elasticsearch/` (k3s 节点)               | 新增   | ES 独立 Helm Chart                |
| `resources/helm-charts/skywalking/` (k3s 节点)                  | 新增   | SkyWalking 自定义 Helm Chart      |
