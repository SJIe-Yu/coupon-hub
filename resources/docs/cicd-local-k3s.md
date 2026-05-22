# GitHub Actions 到本机 Multipass/k3s 的 CI/CD 流程

本文记录当前项目的 CI/CD 设计，以及为什么 CD 使用 self-hosted runner。

## 核心方案

CI 使用 GitHub-hosted runner：

- 编译全部 Maven 模块。
- 编译测试代码。
- 通过 Testcontainers 启动 `mysql:8.0`。
- 使用 Flyway 验证 `resources/database` 下的数据库脚本。

CD 使用本机 self-hosted runner：

- runner 安装在本机 Mac 或能访问 Multipass/k3s 的机器上。
- runner 需要 label：`coupon-hub-k3s`。
- CD job 通过本地网络访问 k3s、Docker、Helm、kubectl。
- 不把本机 k3s API 暴露到公网。

## 为什么不用 GitHub-hosted runner 直接部署本机 k3s

GitHub-hosted runner 在 GitHub 云端，它默认访问不到本机 Multipass 网络。

强行开放本机 k3s API 会带来几个问题：

- 需要公网入口或内网穿透。
- kubeconfig 和集群 token 暴露面变大。
- 本机网络、IP、端口变化会让 CD 不稳定。

self-hosted runner 更适合这个场景。CI 仍在云端执行，只有需要访问本机资源的 CD job 在本地执行。

## 需要准备的本机 runner

在 GitHub 仓库设置中添加 self-hosted runner，并给它增加 label：

```text
coupon-hub-k3s
```

runner 所在机器需要安装：

```text
JDK 17
Docker
kubectl
helm
multipass
```

并确保当前用户可以执行：

```bash
docker ps
kubectl get nodes
helm list -A
```

## GitHub Secrets

CD workflow 需要以下 Secrets：

```text
LOCAL_K3S_MYSQL_JDBC_URL
LOCAL_K3S_MYSQL_USERNAME
LOCAL_K3S_MYSQL_PASSWORD
```

本地开发环境通常可以配置为：

```text
LOCAL_K3S_MYSQL_JDBC_URL=jdbc:mysql://192.168.252.4:30306/
LOCAL_K3S_MYSQL_USERNAME=root
LOCAL_K3S_MYSQL_PASSWORD=root123456
```

如果 GHCR package 是 private，需要在 k3s 中额外创建 image pull secret，或把学习环境镜像包设置为 public。

## Workflow

CI 文件：

```text
.github/workflows/ci.yml
```

触发方式：

- pull request
- push main
- 手动 workflow_dispatch

CD 文件：

```text
.github/workflows/cd-local-k3s.yml
```

触发方式：

- main 分支 CI 成功后自动触发
- 手动 workflow_dispatch

## CD 执行顺序

CD job 在 self-hosted runner 上执行：

1. checkout 通过 CI 的 commit。
2. 登录 GHCR。
3. 使用 `Dockerfile.service` 构建业务服务镜像。
4. 推送镜像到 GHCR。
5. 运行 `database-migration`，对 k3s MySQL 执行 Flyway 迁移。
6. 使用 `resources/helm-charts/coupon-hub-app` 发布服务。
7. 等待每个 Deployment rollout 成功。

当前初版 CD 默认发布全部业务服务：

```text
merchant-admin
engine
settlement
search
gateway
```

后续可以基于 `dorny/paths-filter` 的变更结果，把 CD 优化成只发布受影响服务。

## 泛化到其他项目

可以复用这个模式：

1. CI 始终放在云端，做编译、单测、Testcontainers 集成测试。
2. CD 只在能访问目标集群的 runner 上执行。
3. 数据库迁移作为独立模块或独立 job，放在应用部署前。
4. 应用服务使用统一 Dockerfile 和通用 Helm chart。
5. 先全量发布打通链路，再按路径变更优化成服务级发布。
