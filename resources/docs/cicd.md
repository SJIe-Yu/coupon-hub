# coupon-hub CI/CD 设计文档

## 一、解决的问题

### 构建与测试自动化

每次 `git push` 或 PR 自动触发编译、单元测试、集成测试，无需开发者在本地手动验证全部模块。集成测试使用 Testcontainers 启动临时 MySQL 容器，验证 Flyway 迁移脚本的 DDL 正确性。

### 按需构建镜像

不是每次变更都打 5 个服务的镜像。通过 `dorny/paths-filter` 检测变更范围：

- **基础模块变更**（pom.xml、framework、api、Dockerfile）：全部重建
- **单个服务变更**：只构建该服务镜像
- **Helm chart 变更**：全部重建
- **workflow_dispatch 手动触发**：全部重建

### 数据库迁移与部署解耦

以前把 Flyway 迁移打成 fat JAR 放在 CD 里执行，源码改了还可能和 CI 测试时的版本不一致。现在：

- CI 用 Testcontainers 验证迁移脚本
- CD 用原生 `flyway-maven-plugin` 连接 k3s MySQL 执行迁移
- 建库逻辑也由 Flyway 管理（`createSchemas=true`），不需要额外的 antrun 脚本

### 镜像一次构建，多处使用

之前 CD 从源码重新 `docker build`，自托管 Runner 压力大、耗时长，且构建产物可能与 CI 测试的代码不一致。现在 CI 构建镜像并推送到 ghcr.io，CD 直接 `helm upgrade` 引用同一 tag，k8s 自动拉取。

---

## 二、应用场景

| 场景 | 触发方式 | 行为 |
|------|---------|------|
| 提 PR | `pull_request` | 编译 + 单元测试 + 按变更范围的集成测试，不构建镜像 |
| 合入 main | `push` 到 main | 编译 + 单元测试 + 按变更范围集成测试 + 按需构建镜像 |
| 手动全量构建 | `gh workflow run CI --ref main` | 全量编译 + 全量单元测试 + 全量集成测试 + 构建全部 5 个镜像 |
| 手动触发部署 | `gh workflow run "CD Local k3s"` | 直接执行 Flyway 迁移 + Helm 部署（不依赖 CI） |

---

## 三、使用方法

### 本地开发

```bash
# 编译（需要 JDK 17）
./mvnw -T 1C -DskipTests compile

# 运行单元测试
./mvnw -T 1C test

# 运行数据库迁移集成测试（需要 Docker）
TESTCONTAINERS_RYUK_DISABLED=true ./mvnw -pl database-migration -am -P it verify

# 本地执行 Flyway 迁移（需要本地 MySQL）
./mvnw -pl database-migration -P migrate process-resources \
  flyway:migrate@migrate-merchant-admin \
  flyway:migrate@migrate-engine \
  flyway:migrate@migrate-settlement \
  -Ddb.host=localhost -Ddb.port=3306 -Ddb.user=root -Ddb.password=xxx
```

### 触发 CI

```bash
# 全量 CI（测试 + 构建全部镜像）
gh workflow run CI --ref main

# 查看运行状态
gh run watch
```

### 触发 CD

```bash
# 手动触发部署（使用最新 main 的镜像）
gh workflow run "CD Local k3s" --ref main
```

---

## 四、CI 管线详解

### 流水线结构

```
推送/PR
  │
  ▼
┌──────────────┐
│ 1. changes   │  路径变更检测 + 生成部署计划
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ 2. build-and-unit-test│  编译全部模块 + surefire 单元测试
└──────┬───────────────┘
       │
       ▼
┌──────────────────┐
│ 3. integration-test│  按变更范围选择性运行 failsafe 集成测试
└──────┬───────────┘
       │
       ▼
┌────────────────────────┐
│ 4. build-and-push-images│  矩阵并行构建 + 推送到 ghcr.io
└────────────────────────┘
```

### Job 1：changes（变更检测）

通过 `dorny/paths-filter@v3` 检测变更，输出各模块标志位，并生成部署计划文件。

**路径过滤器：**

| 过滤器 | 监听路径 | 含义 |
|--------|---------|------|
| `common` | pom.xml、framework/\*\*、api/\*\*、Dockerfile.service、.docker/\*\* | 基础模块 |
| `database` | database-migration/\*\*、resources/database/\*\* | 数据库迁移 |
| `chart` | resources/helm-charts/coupon-hub-app/\*\* | Helm chart |
| `merchant_admin` | merchant-admin/\*\* | 商家管理服务 |
| `engine` | engine/\*\* | 引擎服务 |
| `settlement` | settlement/\*\* | 结算服务 |
| `search` | search/\*\* | 搜索服务 |
| `gateway` | gateway/\*\* | 网关服务 |

**部署计划生成逻辑：**

- `common` 或 `chart` 变更 或 `workflow_dispatch` → 全部 5 个服务入选
- 仅某服务变更 → 只有该服务入选
- 生成 `services.txt` 和 `image-matrix.json`，上传为 artifact

### Job 2：build-and-unit-test（编译 + 单元测试）

```bash
./mvnw -T 1C -DskipTests compile    # -T 1C 多模块并行编译
./mvnw -T 1C test                   # surefire 只跑 *Test.java
```

由于所有服务模块已删除测试文件（仅 database-migration 保留），`mvn test` 实际不执行测试，构建极快。

### Job 3：integration-test（集成测试）

```bash
./mvnw -T 1C -P it verify           # failsafe 跑 *IT.java
```

**按变更范围选择策略：**

- `common` 或 `database` 变更 → 全量 `-P it verify`
- 仅 `merchant_admin` 变更 → `-pl merchant-admin,database-migration -am -P it verify`
- database-migration 总是包含（它的 IT 验证 DB 迁移脚本）

### Job 4：build-and-push-images（镜像构建与推送）

使用 `docker/build-push-action@v6` + BuildKit + GHA 缓存，**矩阵并行**构建 5 个服务镜像。

```bash
docker buildx build \
  --cache-from type=gha,scope=${module} \
  --cache-to type=gha,mode=max,scope=${module} \
  --platform linux/arm64 \
  -t ghcr.io/{owner}/{artifact}:{sha} \
  --push .
```

镜像 tag = commit SHA，保证可追溯。CI 和 CD 通过同一个 SHA 关联（CI 用 `github.sha`，CD 用 `workflow_run.head_sha`）。

---

## 五、CD 管线详解

### 触发条件

```yaml
on:
  workflow_run:          # CI 成功后自动触发
    workflows: [CI]
    branches: [main]
    types: [completed]
  workflow_dispatch:     # 手动触发
```

仅当 CI 结果为 `success` 或手动触发时才执行。

### 运行环境

自托管 Runner，标签 `coupon-hub-k3s`，部署在 multipass k3s 主节点上，可通过 `http://192.168.252.1:8889` 代理访问外网。

### Step 1：下载 CI 部署计划

从 CI 的 artifact 下载 `services.txt`，决定本次需部署哪些服务。

### Step 2：飞路迁移（Flyway Migration）

```bash
./mvnw -pl database-migration -P migrate \
  process-resources \
  flyway:migrate@migrate-merchant-admin \
  flyway:migrate@migrate-engine \
  flyway:migrate@migrate-settlement \
  -Ddb.host=... -Ddb.port=... -Ddb.user=... -Ddb.password=...
```

每次执行 3 个 Flyway 任务，分别对应 3 个业务服务。`-Ddb.*` 参数避免与 Flyway 插件自身属性命名空间冲突。

### Step 3：Helm 部署

```bash
helm upgrade --install {release} resources/helm-charts/coupon-hub-app \
  -f resources/helm-charts/coupon-hub-app/values/{module}.yaml \
  --namespace coupon-hub-dev \
  --set image.repository=ghcr.io/{owner}/{artifact} \
  --set image.tag={sha}
kubectl rollout status deployment/{release} --timeout=1800s
```

只部署变更列表中的服务，而不是总是部署全部。

---

## 六、Docker 构建优化

Dockerfile 采用两层分离策略：

```
Layer 1（缓存友好）: COPY POMs → mvn dependency:go-offline
Layer 2（每次构建）: COPY source → mvn install → mvn package
```

POM 不变时，Layer 1 命中 Docker 缓存，无需重新下载依赖。

配合 BuildKit 的 `--cache-from type=gha`，在 GitHub Actions 上跨构建复用层缓存。

---

## 七、配置一览

| 文件 | 用途 |
|------|------|
| `.github/workflows/ci.yml` | CI 流水线（4 job） |
| `.github/workflows/cd-local-k3s.yml` | CD 流水线（部署到 k3s） |
| `Dockerfile.service` | 多阶段 Docker 构建 |
| `database-migration/pom.xml` | Flyway Maven Plugin（3 个 execution） |
| `database-migration/src/main/resources/db/migration/` | SQL 迁移脚本 |
| `database-migration/src/test/.../DatabaseMigrationIT.java` | Testcontainers 集成测试 |
| `resources/helm-charts/coupon-hub-app/values/` | 各服务的 Helm values |
| `resources/database/README.md` | 数据库迁移说明 |
