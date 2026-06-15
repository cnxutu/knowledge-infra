# 业务工程迁移清单（1.x → 2.0.1）

> **目标读者**：维护 1.x 产品线的 Java 业务开发  
> **目标版本**：2.0.1（star-framework / c-system / c-gateway）  
> **阅读时间**：约 10 分钟  
> **完整版参考**：[system-migration-guide-1x-to-201.md](./system-migration-guide-1x-to-201.md)

---

## 0. 前置确认

以下由基座/运维团队完成后，再开始业务工程迁移：

- [ ] star-framework 2.0.1 已发布到 Nexus
- [ ] c-system 2.0.1 已构建部署
- [ ] c-gateway 2.0.1 已构建部署
- [ ] 前端已确认 Long→String 适配计划

---

## 1. 背景变更（了解即可，无需操作）

### c-infra 合并入 c-system

1.x 中 `c-infra` 为独立微服务，2.0.1 中 infra 代码合并至 `c-system`：

- **路由层面**：`/admin-api/infra/**` 仍可用，但由 `c-system` 处理
- **服务依赖**：不再需要单独部署 `c-infra`
- **Feign 调用**：调用 `c-infra` 的 Feign 接口需改为调用 `c-system`

### c-gateway 动态路由

2.0.1 中新增服务发现自动路由，无需手动配置路由规则：

- **默认规则**：`/admin-api/{服务名}/**` → 自动路由到对应服务
- **示例**：`/admin-api/member-server/users/list` → 自动转发到 `member-server` 服务
- **手动路由**：如需自定义规则，可在 `c-gateway` 配置中覆盖，手动路由优先匹配

> 业务工程无需操作，了解路由规则即可。

---

## 2. 必做 Checklist（不做就编译不过 / 启动不了）

### 1.1 依赖坐标变更

| 变更项 | 1.x | 2.0.1 |
|--------|-----|-------|
| BOM 版本 | `fw-dependencies` `1.x.x` | `fw-dependencies` `2.0.1` |
| artifactId 前缀 | `star-` | `fw-` |
| 健康检查依赖 | 无 / 自行引入 actuator | 必须引入 `fw-spring-boot-starter-actuator` |

**依赖替换**：所有 `star-` 前缀的 artifactId 改为 `fw-`，业务工程自行全局替换。

**健康检查依赖**：必须引入 `fw-spring-boot-starter-actuator`，提供 `/health` 端点供 Docker 健康检查使用：

```xml
<dependency>
    <groupId>com.xmkj.framework</groupId>
    <artifactId>fw-spring-boot-starter-actuator</artifactId>
</dependency>
```

**易遗漏点：**
- `<dependency>` 和 `<exclusion>` 中的 artifactId
- CI/CD 配置文件（`.gitlab-ci.yml`）中的镜像名和脚本路径
- Docker 构建脚本（`COPY` 指令中的 JAR 包名）

### 1.2 包路径变更

| 1.x import | 2.0.1 import |
|------------|--------------|
| `com.xmkj.framework.common.util.ArrayUtils` | `cn.hutool.core.util.ArrayUtil` |
| `com.xmkj.framework.common.util.SetUtils` | `cn.hutool.core.collection.CollUtil` |

业务工程自行全局替换，调用方式同步调整：
- `ArrayUtils.isEmpty(arr)` → `ArrayUtil.isEmpty(arr)`
- `SetUtils.isEmpty(set)` → `CollUtil.isEmpty(set)`

### 1.3 代码替换：API 访问日志

移除自定义的 API 日志过滤器，改用 `@ApiAccessLog` 注解：

```java
@RestController
public class UserController {

    @ApiAccessLog
    @GetMapping("/list")
    public CommonResult<PageResult<UserRespVO>> getUserPage(...) {
        // ...
    }
}
```

### 1.4 Nacos 配置：data-id 改为应用名

```bash
# 1.x 中 data-id 可能是固定值或自定义
# 2.0.1 中 data-id 必须与 spring.application.name 一致

# 在 Nacos 控制台上：
# 1. 创建新的配置文件：your-service.yaml
# 2. 将旧配置内容复制到新文件
# 3. 发布后验证
```

**示例：**
```yaml
spring:
  application:
    name: member-server  # Nacos data-id 将自动取此值
```

### 1.5 application.yaml：环境变量占位符

**所有敏感信息必须改为环境变量占位符：**

```yaml
# 替换前（硬编码）
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        username: nacos
        password: zjyyxy123$%^%
  datasource:
    url: jdbc:mysql://localhost:3306/c-system
    username: root
    password: admin123
  redis:
    host: localhost
    password: admin123

# 替换后（占位符）
spring:
  cloud:
    nacos:
      discovery:
        server-addr: ${NACOS_HOST:localhost}:${NACOS_PORT:8848}
        username: ${NACOS_USERNAME:nacos}
        password: ${NACOS_PASSWORD}
  datasource:
    url: jdbc:mysql://${MYSQL_HOST:localhost}:${MYSQL_PORT:3306}/${MYSQL_C_SYSTEM_DATABASE}
    username: ${MYSQL_USER:root}
    password: ${MYSQL_PASSWORD}
  redis:
    host: ${REDIS_HOST:localhost}
    password: ${REDIS_PASSWORD}
```

> **注意**：`${NACOS_PASSWORD}` 不带默认值，运行时未设置会导致启动失败。

### 1.6 新增本地开发配置：env/local.properties

在业务工程根目录创建 `env/local.properties`（已加入 `.gitignore`）：

```properties
NACOS_HOST=localhost
NACOS_PORT=8848
NACOS_NAMESPACE=public
NACOS_USERNAME=nacos
NACOS_PASSWORD=your-nacos-password
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your-mysql-password
MYSQL_C_SYSTEM_DATABASE=c-system
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your-redis-password
ROCKETMQ_NAMESERVER=localhost:9876
```

**IDEA 配置**：Run Configuration → Environment variables → 加载 `env/local.properties`

### 1.7 日志配置：logback-spring.xml

```xml
<property name="LOG_PATTERN" 
          value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%X{traceId}] %logger{36} - %msg%n"/>
```

---

## 3. 需检查的业务逻辑影响

| 变更项 | 影响 | 适配操作 |
|--------|------|----------|
| **字典类型禁用级联** | 禁用字典类型时，其下所有数据同步禁用 | 检查是否有业务逻辑依赖子数据可用 |
| **字典编码限制 128 位** | 超长编码无法保存 | 检查现有字典编码长度 |
| **部门层级限制 10 级** | 超过 10 级无法创建 | 检查现有部门层级深度 |
| **部门删除级联** | 删除部门会清理子部门及关联用户部门 | 检查部门删除业务逻辑 |
| **手机号校验国际化** | `@Mobile` 支持国际格式，用户增加手机区号 | 默认仍是中国大陆，国际需求需配置地区码 |

---

## 4. 字典发现框架接入（新增能力）

依赖已包含在 `fw-dependencies` 中，无需额外引入。启动时自动扫描 `@DictType` / `@DictItem` 注解并上报到 c-system。

**典型用法：**

```java
@Getter
@AllArgsConstructor
@DictType(type = "device_status", name = "设备状态")
public enum DeviceStatusEnum {

    @DictItem(label = "未激活", value = "0", sort = 1)
    INACTIVE(0),

    @DictItem(label = "在线", value = "1", sort = 2)
    ONLINE(1),

    @DictItem(label = "离线", value = "2", sort = 3)
    OFFLINE(2);

    private final Integer code;
}
```

> 更多用法（部分上报、非连续值、编程式定义、参数说明）详见：[dict-discovery-framework-guide.md](./dict-discovery-framework-guide.md)

---

## 5. CI/CD 流程

### 4.1 业务工程 CI 配置

从 `c-system` 工程复制以下文件到业务工程根目录，按需修改：

| 文件 | 来源 | 需修改项 |
|------|------|----------|
| `.gitlab-ci.yml` | `c-system/.gitlab-ci.yml` | `TARGET_JAR` 确保与 `pom.xml` 的 `finalName` 一致 |
| `ci/settings-template.xml` | `c-system/ci/settings-template.xml` | 一般无需修改 |

> **注意**：`.gitlab-ci.yml` 中的 `except: pushes` 表示 push 到分支不会触发构建，仅 MR/tag 触发。如需 push 即构建，删除该限制。

### 4.2 在 apps.properties 中注册服务

编辑 `star-dockers/microsystem/apps.properties`：

```properties
# 1. 在 apps 列表末尾追加你的服务名
apps=c-system,c-gateway,c-iot,c-tag,your-service

# 2. 新增两行配置
your-service.local_path=./apps/your-service/app.jar
your-service.remote_url=http://${MINIO_HOST}/cicd-release/your-service/${CI_COMMIT_REF_SLUG}/app.jar
```

### 4.3 在 docker-compose.yml 中注册服务

编辑 `star-dockers/microsystem/docker-compose.yml`，复制已有服务（如 `c-iot`）的定义段，修改服务名和端口即可。

### 4.4 部署更新

```bash
# 进入部署工具目录
cd star-dockers/microsystem

# 拉取最新 JAR 并重启变更的服务
bash ./sync-and-restart.sh

# 仅拉取不重启（适合批量更新后统一重启）
bash ./sync-and-restart.sh --download-only
```

### 4.5 新增业务服务的完整步骤

1. **业务工程**：
   - `pom.xml`：`finalName` 设为 `${project.artifactId}`
   - 从 `c-system` copy `.gitlab-ci.yml` + `ci/settings-template.xml`
   - 创建 `env/local.properties`

2. **star-dockers/microsystem**：
   - `apps.properties`：追加服务名 + local_path + remote_url
   - `docker-compose.yml`：复制已有服务段并修改服务名/端口

3. **CI/CD**：
   - GitLab CI 构建 → 上传 MinIO
   - `sync-and-restart.sh` 拉取并部署

---

## 6. 本地开发环境配置

### 5.1 env/local.properties

```properties
NACOS_HOST=localhost
NACOS_PORT=8848
NACOS_NAMESPACE=public
NACOS_USERNAME=nacos
NACOS_PASSWORD=your-password
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_C_SYSTEM_DATABASE=c-system
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your-password
ROCKETMQ_NAMESERVER=localhost:9876
SKYWALKING_ENABLED=false
SKYWALKING_BACKEND_SERVICE=localhost:11800
```

### 5.2 IDEA 启动配置

Run Configuration → Environment variables → 加载 `env/local.properties`

或手动添加：
```
NACOS_HOST=localhost;NACOS_PORT=8848;...
```

---

## 7. 升级后验证清单

### 6.1 构建验证

```bash
mvn clean install -DskipTests
```
- [ ] 编译无错误
- [ ] 无 `star-` 前缀残留
- [ ] 无 `ArrayUtils` / `SetUtils` import 残留

### 6.2 启动验证

```bash
# 本地启动
cd your-service
mvn spring-boot:run
```
- [ ] 无端口冲突
- [ ] Nacos 注册成功（控制台可见服务名 + 实例）
- [ ] 数据库连接正常
- [ ] Redis 连接正常

### 6.3 功能验证

- [ ] 登录/登出正常
- [ ] 核心业务流程通过（至少 1 条完整链路）
- [ ] 字典数据正常加载（如有字典发现接入）
- [ ] 角色/权限管理正常

### 6.4 日志验证

```bash
# 检查日志文件
tail -f star-dockers/microsystem/logs/your-service/your-service-info.log
```
- [ ] 日志文件生成正常（`your-service-info.log`）
- [ ] 日志中包含 `traceId`（如 `[TID:abc123]`）
- [ ] 无 ERROR 级别异常

---

**维护团队**：星目基座开发组  
**最近更新**：2026-04-27（基于 v2.0.1 迁移手册精简）
