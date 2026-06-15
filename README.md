## 微服务系统部署操作文档

## 最简操作步骤
1. 获取部署工具 start-dockers, 分支 release-2.0.0
2. 初始化目录和ip，进入 start-dockers 根目录，执行 init.sh
3. 启动中间件: 进入 middleware 目录，执行 docker compose up -d
4. 启动微服务： 进入 microsystem 目录， 执行 ./sync-and-restart.sh

### 一、环境准备

在开始部署前，请确认以下软件已经安装并运行：

1. Docker 和 Docker Compose
2. Git 工具

### 二、部署工具准备

1. 在服务器上下载部署工具：
    执行脚本： [clone.sh](http://192.168.1.115:9000/obsidian/dyf/2026-03-13/clone.sh)

#### 目录和核心配置介绍：
    1. middleware  中间件
    2. microsystem  后端基座2.0的微服务
    3. middleware/nginx/html  前端应用
    4. init.sh     初始化脚本，必定执行
    5. microsystem/apps.properties   后端应用的包路径配置

2. 初始化应用目录和ip信息
进入部署工具根目录， 执行 init.sh 脚步，填入本机ip


### 三、部署 middleware 中间件服务

#### 1. 目录结构说明

middleware 包含以下组件：
- initdir.sh 初始化文件目录
- MySQL 数据库（含初始化脚本）
- Nginx Web服务器（含前端静态资源）
- RocketMQ 消息队列
- 各组件配置文件

#### 2. 部署步骤

```bash
# 进入 middleware 目录
cd middleware

# 启动所有中间件服务
docker compose up -d
```

此命令会启动以下服务：
- MySQL 数据库服务（端口 3306） 用户名/密码： root/admin123
- Nginx Web服务器（端口 80）
- RocketMQ 消息队列服务（端口 9876）
- redis 缓存服务（端口 6379） 密码：admin123
- nacos 配置中心(端口 8848)   用户名/密码： nacos/zjyyxy123$%^

如果需要调整上述用户名和密码，请修改 middleware/docker-compose.yml 文件中的配置，同时记得同步修改 env.properties 文件中的配置。

#### 3. 初始化数据库

数据库会自动执行 `mysql/initdb` 目录下的 SQL 脚本完成初始化：
- [init_infra.sql](file://C:\Users\work\gitlab\star-dockers\middleware\mysql\initdb\init_infra.sql): infra 模块初始化数据
- [init_system.sql](file://C:\Users\work\gitlab\star-dockers\middleware\mysql\initdb\init_system.sql): system 模块初始化数据
- [init_nacos.sql](file://C:\Users\work\gitlab\star-dockers\middleware\mysql\initdb\init_nacos.sql): nacos 配置中心初始化数据

### 四、部署微服务

#### 1. 目录结构说明

microsystem 包含以下组件：
- apps.properties 服务配置文件,管理springboot的应用最新的jar包
- env.properties 环境配置文件
- docker-compose.yml docker配置文件
- sync-and-restart.sh 启动脚本

#### 2. 准备工作

在部署微服务之前，需要准备相应的 JAR 文件， 并将 JAR 文件复制到 microsystem/apps 目录下替换原来的jar， 或者新增其他服务

```bash
./sync-and-restart.sh
```


#### 3. 配置环境参数

检查 [env.properties](file://C:\Users\work\gitlab\star-dockers\microsystem\env.properties) 文件中的配置是否正确：

```properties
NACOS_HOST=192.168.1.108
NACOS_PORT=8848
NACOS_NAMESPACE=public
NACOS_USERNAME=nacos
NACOS_PASSWORD='zjyyxy123$%^'
MYSQL_HOST=192.168.1.108
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=admin123
MYSQL_C_SYSTEM_DATABASE='c-system'
MYSQL_C_INFRA_DATABASE='c-infra'
REDIS_HOST=192.168.1.108
REDIS_PORT=6379
REDIS_PASSWORD=admin123
ROCKETMQ_NAMESERVER='192.168.1.108:9876'
```

1. 请根据实际网络环境修改 IP 地址
2. 中间件的连接信息根据实际信息调整

#### 4. 部署微服务

```bash
# 进入 microsystem 目录
cd microsystem

# 启动微服务
docker compose up -d
```


此命令会启动以下服务：
- c-gateway 网关服务（端口 48080）
- c-system 系统服务（端口 48081）
- c-infra 基础设施服务（端口 48082）

最终会在 microsystem 目录下输出应用日志：
```
└── logs
    ├── c-gateway
        ├── debug.log
        ├── error.log
        ├── info.log
    ├── c-infra
        ├── debug.log
        ├── error.log
        ├── info.log
        └── sql.log
    └── c-system
        ├── debug.log
        ├── error.log
        ├── info.log
        └── sql.log
```

每个服务都挂载了 Arthas 诊断工具以便进行性能监控和故障排查。

### 四、验证部署

#### 1. 检查服务状态

```bash
# 检查 middleware 服务状态
cd middleware
docker-compose ps

# 检查微服务状态
cd ../microsystem
docker-compose ps
```

#### 2. 访问应用程序

- 应用程序通过 Nginx 提供访问入口，访问地址为：http://192.168.1.108 ， 按需替换成你部署的宿主机ip地址
- 后台网关服务可通过 http://192.168.1.108:48080 直接访问

### 五、常见问题处理

#### 1. 数据库连接问题

如果微服务无法连接数据库，请检查：
- `env.properties` 中的数据库配置是否正确
- MySQL 容器是否正常运行
- 防火墙设置是否允许相应端口通信

#### 2. Nacos 配置中心问题

如果服务无法注册到 Nacos，请检查：
- `env.properties` 中的 Nacos 配置是否正确
- 确认 Nacos 服务是否已正确部署并运行

#### 3. 使用 Arthas 进行诊断

每个微服务容器内都集成了 Arthas 诊断工具，可以通过以下方式使用：

```bash
# 进入容器内部
docker exec -it c-gateway bash

# 使用 Arthas 进行诊断
cd /opt/arthas
./as.sh
```


按照提示选择需要诊断的 Java 进程即可。

### 六、注意事项

1. 部署顺序很重要，必须先启动 middleware 再启动微服务
2. 所有服务的配置文件都在对应目录中，可根据实际情况调整
3. 日志文件保存在各服务对应的 logs 目录中
4. 如需扩展服务实例，可修改 docker-compose.yml 文件进行横向扩展

以上就是完整的部署操作流程，按照此文档操作应该能够顺利完成整个系统的部署。