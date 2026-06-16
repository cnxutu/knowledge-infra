# 项目A/项目B 部署标准化与模板模块设计

## 背景

- 项目A：`D:\workspace\github\knowledge-hub`
- 项目B：`D:\workspace\github\knowledge-infra`
- 项目B当前代码源自公司既有部署分支，目录和服务命名仍偏向公司标准工程。
- 当前目标是将项目B收敛为服务于项目A的专属部署仓，并在项目A中补齐后续新增服务的模板模块。

## 目标

### 项目B目标

- 从项目A中抽取当前已使用和未来标准化需要的中间件，整理到 `middleware/`。
- 基于项目A已有和预留的服务，在 `microsystem/` 中建立统一微服务部署骨架。
- 为当前尚未落地实现的服务预留标准化部署骨架，包含：
  - 服务命名
  - 端口规划
  - JAR 命名规则
  - 健康检查
  - 日志挂载
  - 环境变量接入方式

### 项目A目标

- 在 `knowledge-hub` 根下新增 `knowledge-template` 一级模块。
- 为后续新增服务提供统一模板结构，先包含三类子模块：
  - `xxx-api`
  - `xxx-core`
  - `xxx-bootstrap`

## 现状分析

### 项目A已识别的业务模块

- `kb-auth`
- `kb-gateway`
- `kb-content`
- `kb-message`
- `kb-search`

### 项目A当前已明确的中间件依赖

- `MySQL`
- `Redis`
- `Nacos`
- `Elasticsearch`

### 项目A当前部署侧可保留为标准能力的中间件

- `Nginx`
- `RocketMQ`

说明：
- `kb-auth` 与 `kb-gateway` 已具备较明确的运行配置。
- `kb-content`、`kb-message`、`kb-search` 目前以模块骨架为主，本次在项目B中按“标准骨架”预留，不要求立即可运行。

## 方案选择

本次采用“平衡方案”：

- 项目B完成面向项目A的标准化部署骨架。
- 项目A同步补齐 `knowledge-template` 模板模块。
- 不在本次对现有业务模块做大规模重构，仅为后续扩展建立统一规范。

## 设计方案

### 一、项目B整体定位调整

项目B从“公司通用部署模板”调整为“项目A专属部署仓”。

- `middleware/`：承载项目A需要的中间件及标准预留组件。
- `microsystem/`：承载项目A微服务部署骨架。
- 部署约定以项目A的服务名、依赖关系和未来扩展方向为中心，不再沿用与项目A无关的历史业务命名。

### 二、项目B中间件规划

`middleware/` 纳入以下组件：

- `mysql`
- `redis`
- `nacos`
- `elasticsearch`
- `nginx`
- `rocketmq`

约定：

- `MySQL / Redis / Nacos / Elasticsearch` 视为当前核心链路。
- `Nginx / RocketMQ` 视为标准化体系内的完整预留组件，本次一并纳入。
- 中间件目录、compose 服务名、卷挂载和说明文档统一围绕项目A整理。
- `microsystem/env.properties` 作为微服务统一接入面，不在单个服务 compose 项中硬编码中间件地址。

### 三、项目B微服务骨架规划

#### 服务范围

本次在 `microsystem/` 中统一编排以下服务：

- `kb-gateway`
- `kb-auth`
- `kb-content`
- `kb-message`
- `kb-search`

其中：

- `kb-gateway`、`kb-auth` 为当前重点接入服务。
- `kb-content`、`kb-message`、`kb-search` 为标准骨架预留服务。

#### 命名规则

统一采用以下映射原则：

- 服务名 = Spring 应用名
- 服务名 = 容器名核心标识
- 服务名 = 日志目录名
- JAR 文件名 = `<service-name>-bootstrap.jar`

示例：

- `kb-auth` -> `kb-auth-bootstrap.jar`
- `kb-gateway` -> `kb-gateway-bootstrap.jar`
- `kb-content` -> `kb-content-bootstrap.jar`

#### 端口规划

采用固定端口区间顺延方式：

- 网关保留外部入口端口
- 业务服务使用连续端口段
- 预留服务即使暂未实现，也提前占位端口，避免后续频繁调整 compose

具体端口值在实施时结合现有项目B端口分布落地，但保持以下原则：

- 不与中间件端口冲突
- 不与已有微服务端口冲突
- 形成清晰、可记忆的连续区间

#### 健康检查

统一采用以下优先级：

1. `GET /actuator/health`
2. `GET /health`

约定：

- 当前已可运行服务按统一健康检查写入 compose。
- 预留服务若暂不具备健康端点，则保留标准化健康检查配置位与注释说明。

#### 日志与挂载规则

- 日志目录统一挂载至 `microsystem/logs/<service-name>/`
- 应用 JAR 统一挂载至 `microsystem/apps/`
- 每个服务保留独立日志目录
- 环境变量统一由 `env.properties` 注入

#### `apps.properties` 作用

`apps.properties` 仅负责维护：

- 服务名
- JAR 文件名或下载地址

不再混入运行参数、端口、业务说明等其他内容。

### 四、项目A模板模块设计

#### 顶层位置

在 `knowledge-hub` 根下新增一级模块：

- `knowledge-template`

并由根 `pom.xml` 聚合管理。

#### 模板结构

`knowledge-template` 下先建立一个标准服务模板族，用于表达未来新服务的标准分层。

建议形态：

- `knowledge-template`
  - `knowledge-template-service`
    - `knowledge-template-service-api`
    - `knowledge-template-service-core`
    - `knowledge-template-service-bootstrap`

#### 模块职责

`xxx-api`

- 对外契约
- DTO / VO / Query / Command
- Feign / Dubbo / RPC 接口定义
- 尽量避免实现细节依赖

`xxx-core`

- 核心业务逻辑
- 领域服务
- 持久化访问
- 内部业务装配

`xxx-bootstrap`

- Spring Boot 启动入口
- 配置装配
- Controller 暴露
- 运行期依赖汇总

依赖建议：

- `xxx-core` 可依赖 `xxx-api`
- `xxx-bootstrap` 依赖 `xxx-core`
- `xxx-bootstrap` 视需要依赖 `xxx-api`

### 五、实施边界

本次实施包含：

- 调整项目B的中间件与微服务部署骨架
- 补充项目B对应文档和配置说明
- 在项目A新增 `knowledge-template` 聚合模块及基础子模块骨架
- 在项目A根聚合工程中注册 `knowledge-template`

本次不包含：

- 将现有 `kb-auth`、`kb-content`、`kb-message`、`kb-search` 全量重构为 `api/core/bootstrap` 结构
- 强制让所有预留服务在本次立即具备完整运行能力
- 改造全部历史业务配置到模板结构

## 错误处理与风险控制

- 若项目B中存在公司历史服务名、脚本逻辑或下载配置残留，应优先替换为项目A语义，避免后续误用。
- 若某些预留服务尚无可执行 JAR，本次仅保留清晰占位和注释，不伪造“可运行”状态。
- 若现有健康检查端点不统一，应优先在部署层做好兼容，不在本次直接扩大代码改造范围。
- 若项目A后续决定将存量服务全面迁移到模板结构，应单独开展重构任务，而非在本次夹带进行。

## 测试与验证策略

### 项目B验证

- 校验 `middleware/` 目录中间件编排与说明是否完整
- 校验 `microsystem/` 中服务项是否覆盖全部目标服务
- 校验服务名、端口、日志目录、JAR 命名规则是否一致
- 校验 `env.properties` 与 `apps.properties` 的职责边界是否清晰

### 项目A验证

- 校验根 `pom.xml` 已纳入 `knowledge-template`
- 校验 `knowledge-template` 模块层级和 Maven 聚合关系正确
- 校验模板子模块可被正常识别和构建

## 预期结果

- 项目B成为面向项目A的标准部署仓。
- 项目A新增服务时有统一模板可复用。
- 代码结构和部署结构形成稳定映射。
- 后续新增服务时，只需补模板实例与部署条目，无需再次从零设计目录规范。
