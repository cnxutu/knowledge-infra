# 系统升级迁移手册（1.x → 2.0.1）

> **适用范围**：基于星目体系（star-framework / c-system / c-gateway）1.x 版本开发的业务工程  
> **目标版本**：2.0.1  
> **最后更新**：2026-04-15

---

## 1. 升级概览

### 1.1 版本对照表

| 基座仓库 | 1.x 版本 | 2.0.1 版本 |
|----------|----------|-----------|
| `star-framework` | 1.x | 2.0.1 |
| `c-system` | 1.x | 2.0.1 |
| `c-gateway` | 1.x | 2.0.1 |

### 1.2 升级影响范围

| 层级 | Breaking Changes | 新增功能 | 配置变更 |
|------|-----------------|---------|---------|
| **框架层（star-framework）** | 高（artifactId 前缀变更、API 移除） | 中（字典发现、延时队列、Excel 增强） | 中（BOM 版本、序列化策略） |
| **通用服务层（c-system）** | 高（模块重命名、接口合并、infra 合并） | 高（License、批量导入、菜单同步） | 中（Nacos data-id、日志配置） |
| **网关层（c-gateway）** | 高（工程重命名、包结构重构） | 高（动态路由、灰度、License 校验） | 中（Nacos data-id、路由规则） |

### 1.3 升级路线图

建议按以下顺序分阶段升级，每个阶段完成后验证通过再进入下一阶段：

```
阶段一：框架升级（star-framework 2.0.1 deploy 到 Nexus）
    ↓
阶段二：通用服务升级（c-system 2.0.1 构建部署）
    ↓
阶段三：网关升级（c-gateway 2.0.1 构建部署）
    ↓
阶段四：业务工程适配（依赖升级 + 代码迁移 + 配置调整）
    ↓
阶段五：回归验证（功能测试 + 数据库验证 + 日志检查）
```

---

## 2. 前置条件

### 2.1 环境要求变更

| 组件 | 1.x 要求 | 2.0.1 要求 | 说明 |
|------|---------|-----------|------|
| JDK | 1.8+ | **1.8+** | 无变化 |
| Maven | 3.6+ | **3.6+** | 无变化 |
| MySQL | 5.7+ | **8.0+** | 推荐升级到 8.0 |
| Redis | 5.0+ | **5.0+** | 无变化 |
| Nacos | 1.x | **2.x** | 必须升级 |
| RocketMQ | 4.x | **4.x+** | 无变化 |
| Spring Boot | 2.6.x | **2.7.18** | 框架升级驱动 |
| Spring Cloud | 2020.x | **2021.0.9** | 框架升级驱动 |

### 2.2 核心依赖版本矩阵

| 组件 | 1.x 版本 | 2.0.1 版本 |
|------|---------|-----------|
| Spring Framework | 5.3.x | **5.3.39** |
| Spring Security | 5.7.x | **5.8.16** |
| Spring Cloud Alibaba | 2021.0.5.x | **2021.0.6.2** |
| MyBatis-Plus | 3.5.7 | **3.5.12** |
| Redisson | 3.3x | **3.41.0** |
| Hutool | 5.8.x | **5.8.35** |
| Guava | 31.x | **33.4.8-jre** |
| Lombok | 1.18.30 | **1.18.38** |
| MapStruct | 1.5.x | **1.6.3** |
| FastExcel | 无 | **1.2.0** |
| Swagger (springdoc) | 1.6.x | **2.2.40** |
| XXL-Job | 2.3.x | **2.4.0** |
| Lock4j | 2.2.x | **2.2.7** |
| Druid | 1.2.22 | **1.2.24** |

### 2.3 基座仓库构建顺序

```bash
# 1. star-framework 构建并发布到 Nexus
mvn clean deploy -DskipTests

# 2. c-system 构建
mvn clean install -DskipTests

# 3. c-gateway 构建
mvn clean install -DskipTests
```

> **注意**：必须先发布 star-framework 到 Nexus，c-system 和 c-gateway 才能解析到新版本依赖。

---

## 3. star-framework 迁移清单（框架层）

### 3.1 依赖升级（Breaking Change）

#### 3.1.1 BOM 版本升级

```xml
<!-- 1.x -->
<dependency>
    <groupId>com.xmkj.framework</groupId>
    <artifactId>fw-dependencies</artifactId>
    <version>1.x.x</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>

<!-- 2.0.1 -->
<dependency>
    <groupId>com.xmkj.framework</groupId>
    <artifactId>fw-dependencies</artifactId>
    <version>2.0.1</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

#### 3.1.2 artifactId 前缀变更（全局替换）

| 1.x artifactId | 2.0.1 artifactId | 影响程度 |
|----------------|-----------------|---------|
| `star-common` | `fw-common` | 高 |
| `star-spring-boot-starter-web` | `fw-spring-boot-starter-web` | 高 |
| `star-spring-boot-starter-security` | `fw-spring-boot-starter-security` | 高 |
| `star-spring-boot-starter-mybatis` | `fw-spring-boot-starter-mybatis` | 高 |
| `star-spring-boot-starter-redis` | `fw-spring-boot-starter-redis` | 高 |
| `star-spring-boot-starter-rpc` | `fw-spring-boot-starter-rpc` | 高 |
| `star-spring-boot-starter-monitor` | `fw-spring-boot-starter-monitor` | 高 |
| `star-spring-boot-starter-mq` | `fw-spring-boot-starter-mq` | 高 |
| `star-spring-boot-starter-job` | `fw-spring-boot-starter-job` | 高 |
| `star-spring-boot-starter-protection` | `fw-spring-boot-starter-protection` | 高 |
| `star-spring-boot-starter-excel` | `fw-spring-boot-starter-excel` | 高 |
| `star-spring-boot-starter-websocket` | `fw-spring-boot-starter-websocket` | 高 |
| `star-spring-boot-starter-test` | `fw-spring-boot-starter-test` | 高 |
| `star-spring-boot-starter-biz-tenant` | `fw-spring-boot-starter-biz-tenant` | 高 |
| `star-spring-boot-starter-biz-data-permission` | `fw-spring-boot-starter-biz-data-permission` | 高 |
| `star-spring-boot-starter-biz-ip` | `fw-spring-boot-starter-biz-ip` | 高 |
| `star-spring-boot-starter-env` | `fw-spring-boot-starter-env` | 高 |
| `star-spring-boot-starter-actuator` | `fw-spring-boot-starter-actuator` | 高 |
| `star-license` | `fw-license` | 高 |

> **迁移操作**：全局搜索替换 `star-` → `fw-`（在 pom.xml 中）。注意保留 `star.info.version` 等非依赖项。

#### 3.1.3 Spring Boot / Spring Cloud 版本同步

升级后需要同步更新 Spring Boot 和 Spring Cloud 相关依赖版本，具体版本见 **2.2 核心依赖版本矩阵**。

### 3.2 移除的 API 与替代方案

| 1.x API | 状态 | 2.0.1 替代方案 |
|---------|------|---------------|
| `ArrayUtils` | **已移除** | Hutool `ArrayUtil` / `CollUtil` |
| `SetUtils` | **已移除** | Hutool `CollUtil` |
| 旧版 API 日志过滤器 | **已移除** | `@ApiAccessLog` 注解（`fw-spring-boot-starter-web`） |
| 冗余 mapping 定义 | **已移除** | MapStruct 自动映射 |
| `star-spring-boot-starter-dict-discovery` | **新增** | 注解驱动字典定义（`@DictType` / `@DictItem`） |

#### 3.2.1 ArrayUtils → Hutool 替代

```java
// 1.x
import com.xmkj.framework.common.util.ArrayUtils;
ArrayUtils.isEmpty(arr);

// 2.0.1
import cn.hutool.core.util.ArrayUtil;
ArrayUtil.isEmpty(arr);
```

#### 3.2.2 SetUtils → Hutool CollUtil 替代

```java
// 1.x
import com.xmkj.framework.common.util.SetUtils;
SetUtils.isEmpty(set);

// 2.0.1
import cn.hutool.core.collection.CollUtil;
CollUtil.isEmpty(set);
```

### 3.3 行为变更

#### 3.3.1 数字类型序列化为字符串（Breaking Change）

2.0.1 中 Jackson 配置 `NumberSerializer` 将 `Long` 类型自动序列化为 `String`，防止前端精度丢失。

**影响**：
- 前端接收到的 Long 类型字段（如 id、userId）从数字变为字符串
- 前端代码中涉及 `===` 严格相等比较 Long 字段的需要调整
- 前端 TypeScript 类型定义中 `number` 需改为 `string`

**适配建议**：
- 前端统一将 Long 类型字段按字符串处理
- 如需保持数字类型，可在业务工程的 `application.yaml` 中覆盖 Jackson 配置（不推荐）

#### 3.3.2 手机号校验国际化

2.0.1 中 `@Mobile` 注解支持按地区码和 E.164 国际格式校验。

**影响**：
- 原有 `@Mobile` 校验逻辑默认按中国大陆手机号校验
- 如需支持国际手机号，需配置地区码参数

#### 3.3.3 多租户自动关闭

2.0.1 中未注册多租户配置时，框架自动关闭全局多租户拦截，不再抛出异常。

**影响**：
- 1.x 中未配置多租户会报错，2.0.1 中静默忽略
- 如需开启多租户，需显式配置 `star.tenant.enable=true`

#### 3.3.4 API 路由新增 /custom-api 前缀

2.0.1 中自动识别 `custom controller` 路径并添加 `/custom-api` 前缀。

**影响**：
- 自定义 Controller 的访问路径可能发生变化
- 如需关闭，可通过配置调整

#### 3.3.5 RPC 链路追踪增强

2.0.1 中 RPC 调用自动传递 `X-Source-App` 请求头，标识请求来源。

**影响**：
- OpenFeign 拦截器自动附加请求头，无需手动处理
- 如需自定义请求头透传逻辑，注意与框架默认逻辑冲突

#### 3.3.6 BatchResult 对象结构调整

2.0.1 中 `BatchResult` 对象结构优化，字段可能有调整。

**影响**：
- 使用 `BatchResult` 作为返回类型的接口需注意字段兼容性
- 建议检查所有使用 `BatchResult` 的地方

### 3.4 新增能力（可选接入）

| 能力 | 模块 | 说明 |
|------|------|------|
| **字典发现框架** | `fw-spring-boot-starter-dict-discovery` | 注解驱动字典定义，启动期自动扫描上报 |
| **Redis 延时队列** | `fw-spring-boot-starter-redis` | 基于 Redis 实现任务定时调度 |
| **Excel 导入增强** | `fw-spring-boot-starter-excel` | 保留原始行数据、字典校验与业务校验并行 |
| **操作员信息工具** | `fw-spring-boot-starter-security` | `SecurityFrameworkUtils` 优先取当前操作员 |
| **Validator 单例工厂** | `fw-common` | 避免重复创建 Validator 实例 |

### 3.5 配置变更

#### 3.5.1 Lombok 全局配置

2.0.1 中 `lombok.config` 全局开启：

```properties
lombok.accessors.chain=true      # Setter 返回 this（链式调用）
lombok.tostring.callsuper=CALL   # @ToString 调用父类
lombok.equalsandhashcode.callsuper=CALL  # @EqualsAndHashCode 调用父类
```

**影响**：
- 所有 `@Data` / `@Getter` / `@Setter` 生成的 Setter 返回 `this`
- 如业务代码中有 `void setXxx()` 的依赖，需调整

#### 3.5.2 fw-webapp 父 POM 继承（可选）

Spring Boot 可执行应用可继承 `fw-webapp` 父 POM，自动获得 actuator、git-commit-id、spring-boot-maven-plugin 打包配置。

---

## 4. c-system 迁移清单（通用服务层）

### 4.1 模块结构变更（Breaking Change）

#### 4.1.1 启动模块重命名

| 1.x | 2.0.1 |
|-----|-------|
| `c-system-starter` | `c-system-bootstrap` |

**影响**：
- 打包产物名称从 `c-system-starter.jar` 变为 `c-system-bootstrap.jar`
- Docker 镜像构建脚本、K8s YAML 中引用的 JAR 包名需同步调整
- CI/CD 配置中 `TARGET_JAR` 路径需更新

#### 4.1.2 infra 模块合并到 system

1.x 中 `c-infra` 为独立微服务，2.0.1 中 infra 代码合并至 `c-system`。

**影响**：
- 路由层面：`/admin-api/infra/**` 仍可用，但由 `c-system` 处理而非 `c-infra`
- 数据库层面：infra 相关表（`infra_config`, `infra_file`, `infra_file_config`）仍在 `c-system` 数据库中
- 服务依赖：不再需要单独部署 `c-infra`，但需确保 `c-system` 已包含 infra 能力
- RPC 调用：调用 `c-infra` 的 Feign 接口需改为调用 `c-system`

### 4.2 API 变更

#### 4.2.1 角色管理接口合并

| 1.x | 2.0.1 |
|-----|-------|
| 角色新增/编辑独立接口 + 数据权限分配接口 + 菜单权限分配接口 | **合并为单一接口**，角色 CRUD 与权限分配一体化 |

**影响**：
- 前端调用角色管理接口的参数结构变化
- 后端调用角色服务的代码需适配新接口签名

#### 4.2.2 getUser 接口增强

| 1.x | 2.0.1 |
|-----|-------|
| 返回用户基本信息 | **增加角色标识符数组**（`roleIds`） |

#### 4.2.3 重置密码流程简化

| 1.x | 2.0.1 |
|-----|-------|
| 重置密码需传入旧密码 | **不再需要旧密码** |

#### 4.2.4 用户修改自身密码

| 1.x | 2.0.1 |
|-----|-------|
| 修改密码后强制下线 | **保持登录态，不强制下线** |

#### 4.2.5 按钮停用逻辑

| 1.x | 2.0.1 |
|-----|-------|
| 按钮停用时强制用户下线 | **不再强制下线** |

#### 4.2.6 部门管理调整

| 1.x | 2.0.1 |
|-----|-------|
| 部门层级无明确限制 | **最大限制调整为 10 级** |
| 删除部门仅删除自身 | **级联清理子部门及关联用户的部门信息** |

#### 4.2.7 字典管理调整

| 1.x | 2.0.1 |
|-----|-------|
| 字典编码长度无明确限制 | **调整为 128 位** |
| 字典数据列表无状态展示 | **增加状态展示** |
| 字典同步无应用编码校验 | **增加应用编码校验** |
| 字典类型禁用不影响子数据 | **其下所有字典数据同步置为禁用状态** |
| 字典重复性校验不完整 | **增加类型、名称、标签、键值重复性校验** |

#### 4.2.8 用户管理能力扩展

| 1.x | 2.0.1 |
|-----|-------|
| 角色详情无菜单/角色标识 | **增加关联菜单标识与用户角色标识返回** |
| 不支持批量修改用户状态 | **支持批量修改用户状态** |
| 查询条件有限 | **增加用户昵称与电子邮箱筛选** |

#### 4.2.9 字段长度规范化

| 字段 | 1.x | 2.0.1 |
|------|-----|-------|
| 角色名 | 无明确限制 | **2-50 字符** |
| 用户名 | 无明确限制 | **最大 50 字符** |
| 姓名 | 无空格允许 | **允许中间包含空格** |

### 4.3 新增功能影响

#### 4.3.1 License 授权管理

2.0.1 中新增 License 认证与授权信息管理。

**影响**：
- 网关层（c-gateway）增加了 License 拦截，未授权请求会被拒绝
- 业务工程无需直接处理 License，但需确保部署时已完成授权配置
- License 信息查询接口：`/admin-api/system/license/**`

#### 4.3.2 用户批量导入

2.0.1 中支持 Excel 批量导入用户。

**影响**：
- 导入模板固定为五个核心字段：登录账号、姓名、手机号、电子邮箱、启用状态
- 失败信息可导出并支持多语言原因提示
- 手机号与国家代码字典自动校验

#### 4.3.3 菜单数据同步

2.0.1 中支持菜单数据定时同步，统一使用 UUID 作为主键。

**影响**：
- 菜单表主键从自增 ID 变为 UUID
- 增加 URL 资源变更实时监测能力
- 如有自定义菜单数据，需确认 UUID 兼容性

#### 4.3.4 品牌视图管理

2.0.1 中新增品牌视图接口与操作日志。

**影响**：
- 支持视图权限合并与独立重置/保存
- 新 API 路径：`/admin-api/system/branding/**`

#### 4.3.5 用户/部门 MQ 事件通知

2.0.1 中监听用户与部门数据库变更事件，通过 MQ 发送通知。

**影响**：
- 需要 RocketMQ 正常运行
- 其他服务可消费 `system-user` topic 的变更事件
- 踢下线消息 tag 为 `kickoff`

#### 4.3.6 SkyWalking 链路追踪

2.0.1 中集成 SkyWalking 分布式链路追踪。

**影响**：
- 日志格式统一增加 `traceId` 输出
- 需要部署 SkyWalking Agent
- 日志采集系统需适配新的日志格式

### 4.4 配置变更

#### 4.4.1 Nacos 配置中心

| 1.x | 2.0.1 |
|-----|-------|
| data-id 为固定值或自定义 | **data-id 变更为应用名（`c-system`）** |

**影响**：
- Nacos 上原有的配置文件需重命名为 `c-system.yaml`
- 配置内容保持不变，仅 data-id 变更

#### 4.4.2 日志配置

| 1.x | 2.0.1 |
|-----|-------|
| 日志格式无 traceId | **增加 traceId 输出** |
| 日志文件命名随意 | **统一为 `system-*.log`** |

**影响**：
- `logback-spring.xml` 需调整格式，增加 `%X{traceId}`
- 日志保留策略调整（30 天 / 3 GB）

#### 4.4.3 健康检查端点

2.0.1 中统一健康检查端点配置。

**影响**：
- K8s / Docker 编排中的健康检查探针需适配新的端点路径
- 默认路径：`/actuator/health`

#### 4.4.4 Git 构建信息

2.0.1 中打包时自动嵌入 git 构建信息。

**影响**：
- 增加 `git-commit-id-plugin` 插件配置
- 构建产物中生成 `git.properties` 文件

### 4.5 数据库变更

#### 4.5.1 表结构变更

| 变更项 | 1.x | 2.0.1 | 说明 |
|--------|-----|-------|------|
| 菜单主键 | 自增 ID | **UUID** | 需确认自定义菜单数据兼容性 |
| 字典编码长度 | 无限制 | **128 位** | 需检查超长字典编码 |
| 部门层级 | 无限制 | **最大 10 级** | 需检查现有部门层级深度 |

#### 4.5.2 SQL 初始化脚本优化

2.0.1 中优化了 SQL 初始化脚本与执行效率。

**影响**：
- 新环境部署使用新的 `init.sql`
- 旧环境升级需手动执行增量 SQL（如有）

### 4.6 移除项

| 1.x 项 | 2.0.1 状态 | 说明 |
|--------|-----------|------|
| 自定义 ArrayUtils | **已移除** | 统一使用 Hutool |
| 自定义 SetUtils | **已移除** | 统一使用 Hutool CollUtil |
| 冗余代码 | **已清理** | 不影响业务工程 |

---

## 5. c-gateway 迁移清单（网关层）

### 5.1 工程重命名（Breaking Change）

| 1.x | 2.0.1 |
|-----|-------|
| 旧工程名（如 `star-gateway-server`） | `c-gateway` |

**影响**：
- 包路径统一为 `cn.xm.star.gateway`
- 服务名统一为 `c-gateway`
- Nacos 注册中心中的服务名需同步更新
- Docker 镜像名、K8s 部署名称需同步更新

### 5.2 架构变更

#### 5.2.1 授权服务单体化

1.x 中授权服务可能为独立微服务，2.0.1 中完成授权服务单体化改造，整合至 `c-system`。

**影响**：
- 网关不再直接调用独立授权服务，而是通过 `c-system` 进行 Token 校验和 License 查询
- 减少了微服务数量，简化了部署拓扑

#### 5.2.2 infra 路由指向 c-system

1.x 中 `/admin-api/infra/**` 路由指向 `c-infra`，2.0.1 中指向 `c-system`。

**影响**：
- 网关路由表已更新，无需业务工程调整
- 但需确保 `c-system` 已包含 infra 能力（已合并）

#### 5.2.3 多租户逻辑移除

2.0.1 中网关层移除了多租户逻辑。

**影响**：
- 网关不再处理多租户 Header 透传
- 多租户逻辑下沉至 `c-system` 和框架层
- 如业务工程依赖网关层多租户处理，需调整

#### 5.2.4 包结构重构

2.0.1 中重构了包结构，优化代码组织。

**影响**：
- 自定义扩展网关的代码（如自定义过滤器）需注意包路径变化
- 类名可能有调整，需检查 import 语句

### 5.3 新增功能

#### 5.3.1 动态路由

2.0.1 中增加服务发现自动路由配置，新增微服务自动接入网关，无需手动配置路由规则。

**影响**：
- 新增服务自动通过 Nacos 服务发现接入网关
- 手动路由表与自动路由共存，手动路由优先匹配
- 路由规则：`/admin-api/{serviceId}/**` → `grayLb://{serviceId}`

#### 5.3.2 灰度负载均衡

2.0.1 中支持灰度负载均衡，可按策略将流量分发至不同版本服务实例。

**影响**：
- 所有路由使用 `grayLb://` 协议替代 `lb://`
- 下游服务需在 Nacos 元数据中配置 `version` 和 `tag`
- 网关根据 HTTP Header `version` 和 `tag` 筛选服务实例
- 无灰度 Header 时按 Nacos 默认权重随机路由

#### 5.3.3 License 授权校验

2.0.1 中增加应用启动时的 License 授权校验，未授权应用无法启动；同时增加流量入口实时授权校验，拦截未授权请求。

**影响**：
- 部署时需确保 License 已授权
- 网关会调用 `c-system` 的 `/rpc-api/system/license/check` 接口
- 未授权请求返回 `LICENSE_EXPIRED` 错误

#### 5.3.4 MQ 用户踢下线

2.0.1 中增加用户踢下线消息监听与处理，支持通过 MQ 通知强制用户下线。

**影响**：
- 需要 RocketMQ 正常运行
- 消费 `system-user` topic 的 `kickoff` tag
- 收到消息后清除用户 Token 缓存

#### 5.3.5 环境变量配置

2.0.1 中增加应用环境变量配置能力。

**影响**：
- 支持通过 `env/local.properties` 管理环境变量
- IDEA 启动时可加载环境变量配置
- Docker 多服务共享环境变量

### 5.4 配置变更

#### 5.4.1 Nacos 客户端升级

2.0.1 中升级 Nacos 客户端，修复配置文件加载失败问题。

**影响**：
- Nacos 服务端需为 2.x 版本
- 配置加载方式有调整，旧版 Nacos 1.x 不兼容

#### 5.4.2 Nacos data-id 变更

| 1.x | 2.0.1 |
|-----|-------|
| data-id 为固定值或自定义 | **data-id 变更为应用名（`c-gateway`）** |

#### 5.4.3 日志配置调整

2.0.1 中优化日志配置，增加 traceId 输出。

**影响**：
- `logback-spring.xml` 需调整格式
- 日志文件统一为 `gateway-*.log`

#### 5.4.4 健康检查

2.0.1 中增加 health 检查忽略配置，调整健康检查频率为 1 分钟。

**影响**：
- K8s / Docker 编排中的健康检查探针需适配
- License 校验期间健康检查可能失败，需配置忽略路径

#### 5.4.5 Dockerfile JAR 包名

**注意**：`Dockerfile` 中引用的 JAR 包名为 `star-gateway.jar`，但 `pom.xml` 的 `finalName` 为 `c-gateway`，构建产物名称为 `c-gateway.jar`。**构建或镜像化时请确认产物名称**。

### 5.5 路由规则变更

#### 5.5.1 手动路由表

2.0.1 中完整的手动路由表包含约 20 条规则，涵盖以下服务：

| 服务 | 管理端路径 | App 端路径 |
|------|-----------|-----------|
| c-system | `/admin-api/system/**` | `/app-api/system/**` |
| c-system (infra) | `/admin-api/infra/**` | `/app-api/infra/**` |
| member-server | `/admin-api/member/**` | `/app-api/member/**` |
| bpm-server | `/admin-api/bpm/**` | - |
| report-server | `/admin-api/report/**` | `/jmreport/**`, `/drag/**`, `/jimubi/**` |
| pay-server | `/admin-api/pay/**` | `/app-api/pay/**` |
| mp-server | `/admin-api/mp/**` | - |
| product-server | `/admin-api/product/**` | `/app-api/product/**` |
| promotion-server | `/admin-api/promotion/**` | `/app-api/promotion/**` |
| trade-server | `/admin-api/trade/**` | `/app-api/trade/**` |
| statistics-server | `/admin-api/statistics/**` | - |
| erp-server | `/admin-api/erp/**` | - |
| crm-server | `/admin-api/crm/**` | - |
| ai-server | `/admin-api/ai/**` | - |
| iot-server | `/admin-api/iot/**` | - |

> **新增服务**：如需新增服务路由，在 `application.yaml` 中配置或使用服务发现自动路由。

---

## 6. 业务工程适配指南

### 6.1 依赖适配

#### 6.1.1 BOM 版本升级步骤

1. 修改业务工程根 `pom.xml` 中的 `fw-dependencies` 版本为 `2.0.1`
2. 全局搜索替换所有 `star-` 前缀的 artifactId 为 `fw-`
3. 移除 `ArrayUtils` / `SetUtils` 的依赖（如存在）
4. 如有使用 `star-license`，改为 `fw-license`
5. 执行 `mvn clean install -DskipTests` 验证构建

#### 6.1.2 artifactId 前缀替换清单

以下文件需要全局替换 `star-` → `fw-`：

- 所有 `pom.xml` 文件
- `README.md`（如有引用）
- CI/CD 配置文件（如有引用）
- Docker 构建脚本（如有引用）

**注意事项**：
- 保留 `star.info.version` 等非依赖项中的 `star-`
- 保留 Git 仓库 URL 中的 `star-`
- 保留文档中的 `star-framework` 称呼

### 6.2 代码适配

#### 6.2.1 ArrayUtils / SetUtils → Hutool 替代

全局搜索以下 import 并替换：

| 旧 import | 新 import |
|-----------|----------|
| `com.xmkj.framework.common.util.ArrayUtils` | `cn.hutool.core.util.ArrayUtil` |
| `com.xmkj.framework.common.util.SetUtils` | `cn.hutool.core.collection.CollUtil` |

#### 6.2.2 旧版 API 日志过滤器 → @ApiAccessLog

如有自定义 API 日志过滤器，移除并改用 `@ApiAccessLog` 注解：

```java
// 在 Controller 方法上添加注解
@ApiAccessLog
@GetMapping("/list")
public CommonResult<PageResult<UserRespVO>> getUserPage(...) {
    // ...
}
```

#### 6.2.3 Long 类型前端精度丢失适配

2.0.1 中框架自动将 `Long` 序列化为 `String`，前端需适配：

- **TypeScript 类型**：`number` → `string`
- **JavaScript 比较**：`===` → `==`（或统一转为字符串比较）
- **表单输入**：输入框接收字符串，提交时无需转换

#### 6.2.4 手机号校验国际化适配

如有国际手机号需求，在 `application.yaml` 中配置：

```yaml
star:
  mobile:
    default-region: CN  # 默认中国大陆，支持国际格式时调整
```

#### 6.2.5 多租户配置变更

如需开启多租户，显式配置：

```yaml
star:
  tenant:
    enable: true
```

如不需要多租户，无需配置，框架自动关闭。

#### 6.2.6 RPC 调用增加 X-Source-App

框架自动传递，无需业务代码处理。如需自定义，可通过 `RequestIdFeignInterceptor` 扩展。

### 6.3 配置适配

#### 6.3.1 application.yaml 调整

| 配置项 | 1.x | 2.0.1 | 说明 |
|--------|-----|-------|------|
| `spring.application.name` | 任意 | **应用名** | Nacos data-id 默认为应用名 |
| `star.info.version` | 1.0.0 | **建议同步为 2.0.1** | 版本信息展示 |
| `logging.pattern.console` | 无 traceId | **增加 `%X{traceId}`** | SkyWalking 链路追踪 |
| `spring.jackson` | 默认 | **Long→String** | 框架自动配置 |
| `star.web.api-access-log` | 无 | **启用/禁用** | API 访问日志 |

#### 6.3.2 Nacos data-id 变更

将 Nacos 上的配置文件重命名为应用名：

- `c-system.yaml`（对应 `spring.application.name=c-system`）
- `c-gateway.yaml`（对应 `spring.application.name=c-gateway`）
- 业务工程同理，如 `member-server.yaml`

#### 6.3.3 logback-spring.xml 调整

在日志格式中增加 `traceId`：

```xml
<property name="LOG_PATTERN" value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%X{traceId}] %logger{36} - %msg%n"/>
```

### 6.4 数据库适配

#### 6.4.1 表结构变更

| 变更项 | 影响 | 适配操作 |
|--------|------|---------|
| 菜单主键 UUID | 自定义菜单数据可能使用自增 ID | 检查并迁移为 UUID |
| 字典编码 128 位 | 超长字典编码需截断 | 检查现有字典编码长度 |
| 部门层级 10 级 | 现有部门层级可能超过 10 级 | 检查并调整部门结构 |

#### 6.4.2 字典编码长度变更

如需保留超过 128 位的字典编码，需与基座团队协商。建议按规范调整。

#### 6.4.3 菜单主键 UUID 变更

如有自定义菜单数据（非通过 c-system 管理），需确认：

- 自定义菜单表的主键类型是否为 `VARCHAR(64)`（UUID 格式）
- 外键关联是否正确
- 代码中主键类型是否为 `String`

---

## 7. 部署形式改造

### 7.1 统一环境变量管理

#### 7.1.1 管理原则

1. **`application.yaml` 必须是全量配置**：保证 Nacos 配置中心不可用时，应用可独立运行。
2. **账号密码和中间件连接信息使用环境变量**：如 `${NACOS_HOST:localhost}`，便于 Docker 多服务共享配置。
3. **敏感信息不硬编码**：生产环境的密码、密钥等必须通过环境变量注入，禁止写入 `application.yaml` 或提交到 Git。
4. **本地开发与生产环境分离**：本地开发使用 `env/local.properties`，生产环境通过 CI/CD 或容器编排平台注入。

#### 7.1.2 env/local.properties（本地开发）

业务工程需在项目根目录创建 `env/local.properties`（已被 `.gitignore` 忽略，不提交到仓库）：

```properties
NACOS_HOST=localhost
NACOS_PORT=8848
NACOS_NAMESPACE=public
NACOS_USERNAME=nacos
NACOS_PASSWORD=${NACOS_PASSWORD}
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=${MYSQL_PASSWORD}
MYSQL_C_SYSTEM_DATABASE=c-system
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=${REDIS_PASSWORD}
ROCKETMQ_NAMESERVER=localhost:9876
```

**加载方式**：
- **IDEA**：Run Configuration → Environment variables → 加载 `env/local.properties`
- **Docker Compose**：`env_file: - env.properties`
- **命令行**：`export $(cat env/local.properties | xargs)`

#### 7.1.3 application.yaml 占位符规范

| 配置项 | 1.x（硬编码） | 2.0.1（占位符） |
|--------|-------------|---------------|
| `spring.cloud.nacos.discovery.server-addr` | `localhost:8848` | `${NACOS_HOST:localhost}:${NACOS_PORT:8848}` |
| `spring.cloud.nacos.config.server-addr` | `localhost:8848` | `${NACOS_HOST:localhost}:${NACOS_PORT:8848}` |
| `spring.cloud.nacos.username` | `nacos` | `${NACOS_USERNAME:nacos}` |
| `spring.cloud.nacos.password` | `zjyyxy123$$%^` | `${NACOS_PASSWORD}` |
| `spring.datasource.url` | 固定值 | `jdbc:mysql://${MYSQL_HOST:localhost}:${MYSQL_PORT:3306}/${MYSQL_C_SYSTEM_DATABASE}` |
| `spring.redis.host` | `localhost` | `${REDIS_HOST:localhost}` |
| `spring.redis.password` | `admin123` | `${REDIS_PASSWORD}` |
| `rocketmq.name-server` | `localhost:9876` | `${ROCKETMQ_NAMESERVER:localhost:9876}` |
| `skywalking.collector.backend_service` | 固定值 | `${SKYWALKING_BACKEND_SERVICE:localhost:11800}` |

> **注意**：不带默认值的占位符（如 `${NACOS_PASSWORD}`）必须在运行时提供，否则启动失败。

#### 7.1.4 Docker Compose 环境变量传递

`docker-compose.yml` 中通过 `env_file` 指令加载环境变量文件：

```yaml
services:
  your-service:
    env_file:
      - env.properties  # 加载环境变量
    environment:
      SERVICE_NAME: your-service
      SPRING_CLOUD_NACOS_DISCOVERY_PORT: "48082"
```

`env.properties` 格式与 `env/local.properties` 相同，通常放在 `star-dockers/microsystem/` 目录下，统一管理所有服务的中间件连接信息。

---

### 7.2 GitLab CI 统一部署

#### 7.2.1 CI 流水线架构

采用**两阶段流水线**：`build` → `upload`

| 阶段 | 作业 | 说明 |
|------|------|------|
| `build` | `build-jar` | Maven 构建 JAR（支持 `DEPLOY_TO_NEXUS=true` 发布到 Nexus） |
| `upload` | `upload-to-minio` | 将 JAR 上传到 MinIO 对象存储，供部署脚本拉取 |

#### 7.2.2 业务工程 .gitlab-ci.yml 模板

```yaml
variables:
  GIT_DEPTH: 0
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"
  MAVEN_SETTINGS_PATH: "$CI_PROJECT_DIR/.m2/settings.xml"
  MINIO_JAR_PATH: "${CI_PROJECT_NAME}/${CI_COMMIT_REF_SLUG}/app.jar"
  TARGET_JAR: "target/${CI_PROJECT_NAME}.jar"

stages:
  - build
  - upload

build-jar:
  stage: build
  except:
    - pushes
  tags:
    - for-docker
  image: docker.1ms.run/maven:3.9.12-eclipse-temurin-8
  cache:
    key: "maven-deps-$CI_COMMIT_REF_SLUG"
    paths:
      - .m2/repository
  before_script:
    - mkdir -p .m2
    - cp ci/settings-template.xml .m2/settings.xml
  script:
    - mvn clean package -s "$MAVEN_SETTINGS_PATH" -DskipTests
  artifacts:
    paths:
      - $TARGET_JAR
    expire_in: 1 week

upload-to-minio:
  stage: upload
  except:
    - pushes
  tags:
    - for-docker
  image:
    name: docker.1ms.run/minio/mc:latest
    entrypoint: [""]
  dependencies:
    - build-jar
  script:
    - '[ -n "$MINIO_ENDPOINT" ] || (echo "❌ MINIO_ENDPOINT not set" && exit 1)'
    - '[ -n "$MINIO_ACCESS_KEY" ] || (echo "❌ MINIO_ACCESS_KEY not set" && exit 1)'
    - '[ -n "$MINIO_SECRET_KEY" ] || (echo "❌ MINIO_SECRET_KEY not set" && exit 1)'
    - '[ -n "$MINIO_BUCKET" ] || (echo "❌ MINIO_BUCKET not set" && exit 1)'
    - ls -l "$TARGET_JAR" || (echo "❌ JAR file not found" && exit 1)
    - mc alias set minio "$MINIO_ENDPOINT" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY"
    - mc mb "minio/$MINIO_BUCKET" --ignore-existing
    - mc cp "$TARGET_JAR" "minio/$MINIO_BUCKET/$MINIO_JAR_PATH"
    - echo "✅ Uploaded to $MINIO_ENDPOINT/$MINIO_BUCKET/$MINIO_JAR_PATH"
```

**关键变量说明**：

| 变量 | 说明 | 示例 |
|------|------|------|
| `TARGET_JAR` | 构建产物路径 | `target/member-server.jar` |
| `MINIO_JAR_PATH` | MinIO 存储路径 | `member-server/release-2-1-0/app.jar` |
| `GIT_DEPTH` | Git 克隆深度，`0` 表示完整历史 | `0` |
| `MAVEN_OPTS` | Maven 本地仓库路径 | `.m2/repository` |

#### 7.2.3 ci/settings-template.xml（Maven 配置模板）

```xml
<settings>
    <servers>
        <server>
            <id>maven-snapshots</id>
            <username>admin</username>
            <password>${env.MAVEN_REPO_PASSWORD}</password>
        </server>
        <server>
            <id>maven-releases</id>
            <username>admin</username>
            <password>${env.MAVEN_REPO_PASSWORD}</password>
        </server>
    </servers>
    <profiles>
        <profile>
            <id>nexus</id>
            <activation><activeByDefault>true</activeByDefault></activation>
            <repositories>
                <repository>
                    <id>maven-nexus</id>
                    <url>${NEXUS_URL}</url>
                    <releases><enabled>true</enabled></releases>
                    <snapshots><enabled>true</enabled><updatePolicy>always</updatePolicy></snapshots>
                </repository>
            </repositories>
        </profile>
    </profiles>
    <mirrors>
        <mirror>
            <id>maven-public</id>
            <mirrorOf>*</mirrorOf>
            <url>${NEXUS_URL}</url>
        </mirror>
    </mirrors>
</settings>
```

> 将此文件放在业务工程的 `ci/settings-template.xml`，CI 构建时复制到 `.m2/settings.xml`。

#### 7.2.4 apps.properties 统一配置

`star-dockers/microsystem/apps.properties` 是所有后端服务的注册中心，部署脚本通过此文件拉取 JAR：

```properties
# 服务列表（逗号分隔）
apps=c-system,c-gateway,c-iot,c-tag,your-service

# c-system
c-system.local_path=./apps/c-system/app.jar
c-system.remote_url=http://${MINIO_HOST}/cicd-release/c-system/release-2-0-1/app.jar

# c-gateway
c-gateway.local_path=./apps/c-gateway/app.jar
c-gateway.remote_url=http://${MINIO_HOST}/cicd-release/c-gateway/release-2-0-1/app.jar

# 你的业务服务
your-service.local_path=./apps/your-service/app.jar
your-service.remote_url=http://${MINIO_HOST}/cicd-release/your-server/${CI_COMMIT_REF_SLUG}/app.jar
```

**新增业务服务步骤**：
1. 在 `apps` 列表末尾追加服务名
2. 新增两行配置：`your-service.local_path` 和 `your-service.remote_url`
3. 运行 `sync-and-restart.sh` 即可自动拉取并部署

#### 7.2.5 sync-and-restart.sh 部署脚本

`star-dockers/microsystem/sync-and-restart.sh` 核心能力：

| 能力 | 说明 |
|------|------|
| **增量拉取** | 对比本地与远程 JAR 文件大小，仅更新变更的服务 |
| **SHA256 校验** | 下载后校验文件完整性（如远程提供 `.sha256` 文件） |
| **自动备份** | 替换前自动备份旧 JAR（`app.jar.bak.YYYYMMDD-HHMMSS`） |
| **滚动重启** | 仅重启变更的服务容器，不影响其他服务 |
| **健康检查** | 重启后等待 Docker healthcheck 通过 |

**使用方式**：

```bash
# 进入部署工具目录
cd star-dockers/microsystem

# 拉取并重启变更的服务
bash ./sync-and-restart.sh

# 仅拉取不重启（适合批量更新后统一重启）
bash ./sync-and-restart.sh --download-only
```

---

### 7.3 Docker Compose 服务模板

#### 7.3.1 统一服务模板（YAML 锚点）

`star-dockers/microsystem/docker-compose.yml` 使用 YAML 锚点定义通用服务模板，新增服务只需引用模板并覆盖特定字段：

```yaml
version: "3.8"

x-common-environment: &common-environment
  TZ: Asia/Shanghai
  SERVER_PORT: "8080"
  JAVA_OPTS: "-Xms512m -Xmx512m -Djava.security.egd=file:/dev/./urandom"

x-service-template: &service-template
  image: docker.1ms.run/eclipse-temurin:8-jdk
  working_dir: /app
  command: /app/toolkits/startup_springboot.sh
  env_file:
    - env.properties
  restart: always
  deploy:
    resources:
      limits:
        memory: 768m
        cpus: '1.0'
  logging:
    driver: "json-file"
    options:
      max-size: "100m"
      max-file: "3"
  healthcheck:
    test: [ "CMD", "sh", "-c", "wget -qO- http://localhost:8080/health | grep -q 'OK\\|UP'" ]
    interval: 20s
    timeout: 10s
    retries: 3
    start_period: 60s
```

#### 7.3.2 新增业务服务步骤

在 `services:` 段落末尾追加服务定义：

```yaml
services:
  # ... 已有服务（c-system, c-gateway 等）

  your-service:
    <<: *service-template
    container_name: your-service
    environment:
      <<: *common-environment
      SERVICE_NAME: your-service
      SPRING_CLOUD_NACOS_DISCOVERY_PORT: "48082"
    ports:
      - "48082:8080"
      - "15007:5005"  # JDWP 远程调试端口
    depends_on:
      c-system:
        condition: service_healthy
    volumes:
      - ./apps/your-service:/app/your-service:ro
      - ./logs/your-service:/app/logs
      - ../toolkits:/app/toolkits:ro
```

**无需修改的配置**：
- `env.properties`：所有服务共享同一套中间件连接信息
- `healthcheck`：统一通过 `/health` 端点检查
- `logging`：统一日志轮转策略（100MB / 3 个文件）
- `restart`：统一自动重启策略

---

### 7.4 启动脚本统一

#### 7.4.1 startup_springboot.sh

`star-dockers/toolkits/startup_springboot.sh` 是所有 Spring Boot 服务的通用启动脚本，通过环境变量控制行为：

| 环境变量 | 说明 | 默认值 |
|----------|------|--------|
| `SERVICE_NAME` | 服务名称（对应 JAR 路径） | 必填 |
| `JAVA_OPTS` | JVM 参数 | `-Xms512m -Xmx512m` |
| `JDWP_PORT` | 远程调试端口 | 未定义则不开启 |
| `SKYWALKING_ENABLED` | SkyWalking Agent 开关 | `false` |
| `SKYWALKING_BACKEND_SERVICE` | SkyWalking OAP 地址 | `localhost:11800` |
| `star.env.tag` | 环境标签（灰度路由用） | 空 |
| `star.tenant.enable` | 多租户开关 | `false` |

**脚本逻辑**：
1. 检查 `JDWP_PORT`，如定义则附加远程调试参数
2. 检查 `SKYWALKING_ENABLED`，如 `true` 则挂载 SkyWalking Agent
3. 启动 JAR，日志输出到 `/app/logs/{SERVICE_NAME}.log`

#### 7.4.2 业务服务接入

业务工程无需自定义启动脚本，只需确保：
1. `pom.xml` 中 `finalName` 与 `SERVICE_NAME` 一致（如 `your-service.jar`）
2. `Dockerfile` 中 `COPY` 的 JAR 包名与构建产物一致
3. 提供 `/health` 端点（Spring Boot Actuator 默认已提供）

---

### 7.5 健康检查端点统一

#### 7.5.1 统一端点路径

2.0.1 中统一使用 `/health` 作为 Docker 健康检查端点（`fw-spring-boot-starter-actuator` 提供）：

```yaml
# docker-compose.yml
healthcheck:
  test: [ "CMD", "sh", "-c", "wget -qO- http://localhost:8080/health | grep -q 'OK\\|UP'" ]
  interval: 20s
  timeout: 10s
  retries: 3
  start_period: 60s
```

**返回值**：
- `UP`：服务正常运行
- `DOWN`：服务异常（如数据库连接失败）
- `OK`：简化健康检查返回（兼容旧版）

#### 7.5.2 服务依赖与健康检查联动

```yaml
services:
  c-gateway:
    depends_on:
      c-system:
        condition: service_healthy  # 等待 c-system 健康后才启动
```

> **注意**：c-gateway 依赖 c-system 健康检查通过后才启动，避免网关先启动导致路由失败。

---

### 7.6 Nacos 配置管理规范

#### 7.6.1 配置分层优先级

| 层级 | 配置源 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 命令行参数 | 最高 | `--server.port=8080` |
| 2 | 环境变量 | 高 | `SERVER_PORT=8080` |
| 3 | Nacos 配置中心 | 中 | `your-service.yaml` |
| 4 | `application.yaml` | 低 | 全量默认值 |

#### 7.6.2 配置迁移步骤（1.x → 2.0.1）

1. **本地 `application.yaml`**：
   - 确保为全量配置（所有配置项均有默认值）
   - 将硬编码的敏感信息替换为环境变量占位符

2. **Nacos 配置中心**：
   - 将旧的配置文件 data-id 重命名为应用名（如 `your-service.yaml`）
   - 保留动态调整的配置项（如日志级别、超时时间）
   - 移除与环境变量重复的配置项（如数据库连接信息）

3. **环境变量**：
   - 生产环境的密码、密钥通过 CI/CD 或容器平台注入
   - 开发环境通过 `env/local.properties` 管理

---

### 7.7 日志与监控统一

#### 7.7.1 日志文件命名规范

| 日志文件 | 级别 | 说明 |
|----------|------|------|
| `{service-name}-info.log` | INFO + WARN | 主要业务日志 |
| `{service-name}-error.log` | ERROR | 错误日志 |
| `{service-name}-debug.log` | DEBUG | 调试日志（保留 7 天） |
| `{service-name}-sql.log` | DEBUG | MyBatis SQL 日志（保留 7 天） |

日志统一输出到 `star-dockers/microsystem/logs/{service-name}/` 目录，通过 Docker volume 挂载到宿主机。

#### 7.7.2 traceId 输出要求

`logback-spring.xml` 中日志格式必须包含 `traceId`：

```xml
<property name="LOG_PATTERN" 
          value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%X{traceId}] %logger{36} - %msg%n"/>
```

> `traceId` 由 SkyWalking Agent 或框架自动生成，用于全链路追踪。

#### 7.7.3 SkyWalking 接入

通过环境变量开关控制：

```properties
# env.properties
SKYWALKING_ENABLED=true
SKYWALKING_BACKEND_SERVICE=192.168.1.108:11800
```

启动脚本自动挂载 Agent：

```bash
-javaagent:/app/toolkits/skywalking-agent/skywalking-agent.jar
-Dskywalking.agent.service_name=${SERVICE_NAME}
-Dskywalking.collector.backend_service=${SKYWALKING_BACKEND_SERVICE}
```

---

### 7.8 完整改造示例

#### 7.8.1 改造前后对照（业务工程）

| 文件 | 1.x | 2.0.1 |
|------|-----|-------|
| `pom.xml` | `star-dependencies` 1.x | `fw-dependencies` 2.0.1 |
| `.gitlab-ci.yml` | 无（手动构建） | 两阶段流水线 build+upload |
| `env/local.properties` | 无 | 新增（环境变量管理） |
| `ci/settings-template.xml` | 无 | 新增（Maven 私服配置） |
| `application.yaml` | 硬编码敏感信息 | 环境变量占位符 |
| `Dockerfile` | 自定义启动脚本 | 复用 `startup_springboot.sh` |
| `docker-compose.yml` | 独立配置 | 引用 `x-service-template` |

#### 7.8.2 部署验证清单

- [ ] GitLab CI 流水线 build 阶段通过
- [ ] GitLab CI 流水线 upload 阶段通过，MinIO 上可见 JAR 包
- [ ] `sync-and-restart.sh` 拉取 JAR 成功（大小对比 + SHA256 校验）
- [ ] Docker 容器启动成功（`docker compose ps` 状态为 `Up`）
- [ ] Docker healthcheck 通过（状态为 `healthy`）
- [ ] Nacos 服务注册成功（控制台可见服务名 + 实例数）
- [ ] 日志目录生成且包含 `*-info.log`
- [ ] 日志中可见 `traceId`（如 `[TID:abc123]`）
- [ ] SkyWalking 链路追踪正常（如开启）
- [ ] 网关路由正常（`/admin-api/your-service/**` 可访问）

---

## 8. 回滚方案

### 8.1 回滚策略

#### 7.1.1 基座版本回退

如需回退 star-framework 版本：

1. 在 Nexus 上保留旧版本（releases 仓库不可删除）
2. 修改业务工程 `pom.xml` 中的 `fw-dependencies` 版本回退
3. 重新构建部署

#### 7.1.2 数据库回退

- 升级前备份完整数据库
- 如有增量变更脚本，需准备对应的回滚脚本
- 菜单 UUID 主键变更不可逆，升级前需充分验证

#### 7.1.3 配置回退

- Nacos 配置保留历史版本（开启配置历史记录）
- 本地 `application.yaml` 保留在 Git 中，可随时回退

### 8.2 回滚检查点

| 阶段 | 验证点 | 回滚触发条件 |
|------|--------|-------------|
| 阶段一 | star-framework 构建成功、Nexus 发布成功 | 构建失败、Nexus 发布失败 |
| 阶段二 | c-system 启动成功、健康检查通过 | 启动失败、健康检查失败、License 校验失败 |
| 阶段三 | c-gateway 启动成功、路由正常 | 启动失败、路由不通、License 校验失败 |
| 阶段四 | 业务工程构建成功、单元测试通过 | 构建失败、测试失败 |
| 阶段五 | 核心业务流程通过、日志无异常 | 功能异常、性能下降、数据不一致 |

---

## 9. 常见问题与注意事项

### 9.1 artifactId 前缀变更最容易遗漏的替换点

以下位置容易被遗漏，需重点检查：

- `pom.xml` 中的 `<dependency>` 和 `<exclusion>`
- `pom.xml` 中的 `<plugin>`（如 spring-boot-maven-plugin 不受此影响）
- CI/CD 配置文件（如 `.gitlab-ci.yml` 中的镜像名、脚本中的路径）
- Docker 构建脚本（如 `COPY` 指令中的 JAR 包名）
- K8s YAML 文件（如 `image` 字段中的镜像名）
- 文档和 README

### 9.2 Dockerfile JAR 包名一致性问题

`c-gateway` 的 `Dockerfile` 中引用 `star-gateway.jar`，但 `pom.xml` 的 `finalName` 为 `c-gateway`。构建时产物名称为 `c-gateway.jar`，**需确认 Dockerfile 中 COPY 的 JAR 包名与实际产物一致**。

### 9.3 多模块依赖安装顺序

```bash
# 正确的构建顺序
mvn install -pl fw-dependencies -DskipTests
mvn install -pl fw-common -DskipTests
mvn install -pl fw-spring-boot-starter-web -DskipTests
# ... 其他框架模块
mvn install -pl c-system-api -DskipTests
mvn install -pl c-system-core -DskipTests
mvn install -pl c-system-bootstrap -DskipTests
```

> 如遇到跨模块符号无法解析，按依赖链顺序逐个安装。

### 9.4 Nacos 配置中心 data-id 迁移

升级后 Nacos data-id 变更为应用名，需：

1. 在 Nacos 控制台上创建新的配置文件（data-id = 应用名）
2. 将旧配置内容复制到新配置文件
3. 发布后验证配置加载成功
4. 旧配置文件可保留一段时间作为备份

### 9.5 框架序列化行为变更对前端的影响

**最重要**：2.0.1 中 `Long` 类型自动序列化为 `String`，前端需全面检查：

- 所有接收后端 `Long` 类型字段的地方
- `===` 严格相等比较
- `parseInt()` / `parseFloat()` 转换
- TypeScript 类型定义
- 表单验证规则

### 9.6 健康检查端点对 K8s / Docker 编排的影响

2.0.1 中统一健康检查端点为 `/actuator/health`，K8s 探针配置需同步更新：

```yaml
# K8s livenessProbe / readinessProbe
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 48081
readinessProbe:
  httpGet:
    path: /actuator/health
    port: 48081
```

### 9.7 字典类型禁用级联逻辑对业务的影响

2.0.1 中字典类型禁用时，其下所有字典数据同步置为禁用状态。

**影响**：
- 前端下拉框中禁用的字典类型及其子数据不再显示
- 已有数据中使用该字典类型的记录不受影响（仅影响新数据选择）
- 如需保留子数据启用，需调整业务逻辑

### 9.8 升级前必检清单

- [ ] 确认所有 `pom.xml` 中的 `star-` 前缀已替换为 `fw-`
- [ ] 确认 `ArrayUtils` / `SetUtils` 已替换为 Hutool
- [ ] 确认 Nacos 已升级到 2.x
- [ ] 确认 MySQL 已升级到 8.0（推荐）
- [ ] 确认数据库已备份
- [ ] 确认前端已适配 Long→String 序列化
- [ ] 确认 CI/CD 配置中的 JAR 包名已更新
- [ ] 确认 K8s / Docker 健康检查探针已更新
- [ ] 确认 License 已授权（生产环境）
- [ ] 确认 RocketMQ 正常运行（用于踢下线功能）

---

**维护团队**：星目基座开发组  
**最近更新**：2026-04-15（v2.0.1）
