# knowledge-infra

面向 `knowledge-hub` 的部署与运维仓，负责中间件、微服务编排、初始化脚本、JAR 同步与运行期诊断。

## 最简流程

1. 进入仓库根目录，执行 `bash init.sh`
2. 执行 `bash startup.sh`
3. 验证 `middleware` 和 `microsystem` 服务状态

## 当前部署范围

### middleware 核心链路

- `mysql`
- `redis`
- `nacos`
- `elasticsearch`
- `nginx`
- `rocketmq`

说明：

- `MySQL / Redis / Nacos / Elasticsearch` 是当前项目A核心链路。
- `Nginx / RocketMQ` 已纳入标准部署体系，便于后续扩展。
- 仓库中仍保留部分公司历史目录，如 `tdengine`、`skywalking`、`prometheus`、`xxljob`，但它们不属于当前默认启动链路。

### microsystem 服务清单

- `kb-gateway`
- `kb-auth`
- `kb-content`
- `kb-message`
- `kb-search`

说明：

- `kb-gateway`、`kb-auth` 是当前优先接入服务。
- `kb-content`、`kb-message`、`kb-search` 先按标准骨架预留，具备端口、JAR、日志、健康检查约定，但默认不保证已有可运行 JAR。

## 目录说明

### `middleware/`

- `docker-compose.yml`：默认中间件启动入口
- `initdir.sh`：初始化目录与数据卷目录
- `nginx/`：网关静态页与反向代理配置
- `rocketmq/`：Broker 配置
- `elasticsearch/`：ES 单机配置

### `microsystem/`

- `docker-compose.yml`：`kb-*` 微服务部署入口
- `env.properties`：统一中间件接入参数
- `apps.properties`：服务名与 JAR 路径映射
- `sync-and-restart.sh`：JAR 同步与按服务重建

## 初始化与启动

### 1. 初始化目录与配置替换

```bash
bash init.sh
```

`init.sh` 会执行以下动作：

- 初始化 `middleware` 所需目录
- 尝试同步 Nginx 前端资源
- 以 `--download-only` 模式处理 `microsystem/apps.properties`
- 执行 `replace_ip.sh` 将模板 IP `192.168.1.108` 替换为当前宿主机 IP

如果 `middleware/nginx/frontend-apps.properties` 中未配置前端资源，前端同步会自动跳过。

### 2. 启动整套环境

```bash
bash startup.sh
```

启动顺序：

1. `shutdown.sh` 清理旧容器
2. 启动 `middleware`
3. 等待 `nacos` healthy
4. 启动 `microsystem`
5. 等待 `microsystem` 中所有服务 healthy

### 3. 停止整套环境

```bash
bash shutdown.sh
```

## 微服务 JAR 约定

`microsystem/apps.properties` 使用统一规则：

- 服务名 = Spring 应用名 = 容器名 = 日志目录名
- JAR 文件名 = `<service-name>-bootstrap.jar`

示例：

- `kb-auth` -> `./apps/kb-auth/kb-auth-bootstrap.jar`
- `kb-gateway` -> `./apps/kb-gateway/kb-gateway-bootstrap.jar`

如果某个服务尚未接入远端制品下载，可使用 `manual://` 前缀：

```properties
kb-search.remote_url=manual://kb-search
```

这表示脚本会保留目录结构，但跳过远端下载。

## 关键配置

`microsystem/env.properties` 当前维护：

- Nacos 连接信息
- MySQL 连接信息
- Redis 连接信息
- RocketMQ nameserver 地址
- Elasticsearch 地址
- 预留业务数据库名

模板值默认以 `192.168.1.108` 为占位，首次部署后应替换为实际宿主机 IP。

## 验证方式

### 检查容器状态

```bash
cd middleware
docker compose ps

cd ../microsystem
docker compose ps
```

### 访问入口

- Nginx：`http://<宿主机IP>/`
- Gateway：`http://<宿主机IP>:48080/`
- Nacos：`http://<宿主机IP>:8848/nacos`
- Elasticsearch：`http://<宿主机IP>:9200/`
- RocketMQ Console：`http://<宿主机IP>:6060/`

## 常见问题

### Nacos 注册异常

- 检查 `SPRING_CLOUD_NACOS_DISCOVERY_IP`
- 检查 `NACOS_HOST`、`NACOS_PORT`
- 确保 `knowledge-nacos` 已 healthy

### JAR 未启动

- 检查 `apps.properties` 中的 `local_path`
- 检查对应目录下是否已放置 `*-bootstrap.jar`
- 检查 `toolkits/startup_springboot.sh` 输出日志

### 预留服务健康检查失败

- 若服务还未产出真实 JAR，启动时失败属于预期现象
- 这类服务的部署骨架已经预留，等对应服务产出包后即可接入
