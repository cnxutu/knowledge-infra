# AGENTS

## 作用范围

本文件对整个 `knowledge-infra` 仓库生效；如果子目录下存在更深层的 `AGENTS.md`，则以更近的文件为准。

## 仓库定位

- `knowledge-infra` 是一个面向 Spring Cloud 微服务系统的部署与运维仓。
- 重点不是业务源码编译，而是：
  - Docker Compose 编排
  - 中间件与微服务启停
  - 初始化脚本
  - 远端制品下载
  - 环境参数与 IP 替换
  - 日志排障与运维辅助脚本
- 默认不要把它当成“可正常 Maven 编译的业务仓”来处理。
- 本仓更多承担“部署入口”和“运维手册落地点”的角色。

## 目录地图

### `middleware/`

- 角色：中间件层。
- 通常包含：
  - MySQL
  - Nginx
  - RocketMQ
  - Redis
  - Nacos
- 这是整个部署链路的第一阶段，必须先健康。

### `microsystem/`

- 角色：后端微服务层。
- 通常包含：
  - 微服务 JAR 包
  - `apps.properties`
  - `env.properties`
  - `docker-compose.yml`
  - `sync-and-restart.sh`
- 这是第二阶段启动区域，依赖中间件先就绪。

### `bizservices/`

- 角色：补充业务服务或简化业务容器区。
- 与 `microsystem/` 相比，通常更轻量，部分服务没有完整健康检查与优雅重启逻辑。

### `toolkits/`

- 角色：运维辅助工具区。
- 常见用途包括 Arthas、诊断脚本、排障配套文件。

### `bin/`

- 角色：通用辅助脚本目录。
- 当前已知包括日志分析类脚本，例如 `log-monitor.sh`。

## 核心命令

```bash
# 首次初始化：创建目录、下载 JAR / 前端、替换 IP
bash init.sh

# 启动整套环境：通常会先停旧环境，再按顺序启动
bash startup.sh

# 停止整套环境
bash shutdown.sh

# 下载更新后的 JAR 并重启受影响服务
cd microsystem && bash sync-and-restart.sh

# 下载前端静态资源
cd middleware/nginx && bash sync-frontend.sh

# 替换模板 IP
bash replace_ip.sh
```

## 启动顺序与架构约束

```
middleware/  -> microsystem/  -> bizservices/
(step 1)        (step 2)         (step 3)
```

- 启动顺序是严格串行的，不能随意颠倒。
- 中间件，尤其是 `Nacos`，必须先健康，再启动微服务。
- 微服务内部也存在依赖链，例如：
  - `c-system (healthy) -> c-gateway, c-iot, c-tag`
  - `c-iot (healthy) -> c-iot-gateway`
- 若修改 compose 配置、健康检查或脚本时破坏了这个顺序，联调很容易出现“服务已起但不可用”的假成功。

## Shell 脚本约定

- 所有脚本实际运行时按 `bash` 处理，而不是严格 POSIX `sh`。
- 原因是现有脚本使用了 `declare -A`、`[[ ]]`、`${!var[@]}` 等 bash 特性。
- 即使个别脚本 shebang 看起来像 `#!/bin/sh`，也不要贸然按纯 `sh` 语法重构。
- `startup.sh` 与 `shutdown.sh` 使用 `set -euo pipefail`。
- 有些脚本依赖 `OLDPWD` 在 `cd` 后返回原目录。
- 该仓默认没有完善的 lint 或自动化测试体系，修改脚本后应以实际执行路径验证为主。

## IP 与环境参数管理

- `192.168.1.108` 是模板 IP，很多配置文件都以它作为占位值。
- `replace_ip.sh` 会扫描非数据、非日志文件并替换该 IP。
- 典型流程是：先执行 `init.sh`，再执行 `replace_ip.sh`，最后首次 `startup.sh`。
- 关键配置文件包括：
  - `microsystem/env.properties`
  - `bizservices/env.properties`
  - `microsystem/apps.properties`
- 如果修改脚本或模板配置，优先保证“新环境一键初始化”仍然成立。

## 关键风险点

### Nacos 注册 IP

- `env.properties` 中的 `SPRING_CLOUD_NACOS_DISCOVERY_IP` 必须等于宿主机真实 IP。
- 配错后，服务虽然可能启动成功，但会以错误地址注册到 Nacos，导致其他服务不可达。

### env 文件加载方式

- 现有 compose 主要通过 `env_file:` 加载环境文件，而不是内联环境变量。
- 调整变量名或文件路径时，要同时检查 compose 与脚本侧是否一致。

### 远端制品下载不是可选项

- 该仓默认依赖远端 CI 下载 JAR 和前端资源。
- 所以“本地 build 成功”并不等于“部署链路可用”。
- 修改下载逻辑、路径映射、校验逻辑时，要优先关注可部署性。

## 健康检查与运行时约定

- 微服务通常暴露 `GET /health`，返回内容包含 `OK` 或 `UP`。
- 典型健康检查命令：

```bash
wget -qO- http://localhost:8080/health | grep -q 'OK\|UP'
```

- 基础镜像当前为 `docker.1ms.run/eclipse-temurin:8-jdk`。
- 默认 JVM 堆配置通常为 `-Xms512m -Xmx512m`。
- 容器内存限制典型值为 `768m`。
- `bizservices` 中的简单服务可能没有完整健康检查或优雅重启逻辑，调整时要额外注意。

## 调试与排障入口

### 远程调试

- `env.properties` 中的 `JDWP_PORT=5005` 用于启用远程调试。
- 各服务会将该端口映射到不同宿主机端口，例如 `15005` 到 `15009`。

### Arthas

- Arthas 通过卷挂载进入容器。
- 常见使用方式：

```bash
docker exec -it <container> bash
/opt/arthas/as.sh
```

### 日志

- 日志会挂载到宿主机，例如 `microsystem/logs/<service-name>/`。
- `bin/log-monitor.sh` 用于按时间窗口统计错误并辅助排查。
- `microsystem/find_error.sh` 是更轻量的错误搜索脚本。

## JAR 更新机制

- `sync-and-restart.sh` 主要通过比对远端与本地 JAR 的文件大小来判断是否需要更新。
- 如果大小不一致，会下载新包、按条件校验 SHA256、备份旧包并重启容器。
- `--download-only` 可只下载不重启，`init.sh` 会用到这个模式。
- 远端 JAR 地址定义在 `microsystem/apps.properties` 中。

## 建议阅读顺序

1. 本文件
2. `README.md`
3. `arch.txt`
4. `init.sh`、`startup.sh`、`shutdown.sh`
5. 目标子目录下的 `docker-compose.yml`、`env.properties`、`apps.properties`

## 文档维护约定

- 如果调整了目录职责、部署步骤、默认端口、模板 IP、健康检查方式，请同步更新本文件与 `README.md`。
- 如果新增一类重要脚本或新的部署层级，建议在相应子目录补充更近一层的 `AGENTS.md`。
- 如果某个脚本存在“必须这样做”的隐含前置条件，应优先写进文档，而不是只留在口头经验里。
