# 前端资源自动化部署指南

## 概述

前端静态资源通过配置文件管理，支持从远程服务器自动下载和更新。Nginx 会自动提供最新的静态文件，无需 reload。

## 脚本结构

```
star-dockers/
├── microsystem/
│   └── sync-and-restart.sh      # 后端微服务同步脚本（独立）
└── middleware/nginx/
    ├── sync-frontend.sh          # 前端资源同步脚本（独立）
    └── frontend-apps.properties  # 前端应用配置
```

**设计原则**：
- 前后端脚本相互独立，避免耦合
- 每个脚本只关注自己的资源类型
- 单一职责，易于维护

## 使用方法

### 前端资源同步

```bash
# 进入 nginx 目录
cd middleware/nginx

# 同步所有前端资源（下载并更新）
bash sync-frontend.sh

# 仅下载不更新（预检查）
bash sync-frontend.sh --download-only
```

### 后端服务同步

```bash
# 进入 microsystem 目录
cd microsystem

# 同步所有后端服务（下载并重启容器）
bash sync-and-restart.sh

# 仅下载不重启（预检查）
bash sync-and-restart.sh --download-only
```

## 配置文件语法

### 前端资源配置 (middleware/nginx/frontend-apps.properties)

```properties
apps=vmicro-app-main,vmicro-app-login,vmicro-app-fly-ctrl

vmicro-app-main.local_path=./html/vmicro-app-main
vmicro-app-main.remote_url=http://192.168.1.115:9000/cicd-release/frontend/vmicro-app-main/latest/vmicro-app-main.zip
vmicro-app-main.extract=true

vmicro-app-login.local_path=./html/vmicro-app-login
vmicro-app-login.remote_url=http://192.168.1.115:9000/cicd-release/frontend/vmicro-app-login/latest/vmicro-app-login.zip
vmicro-app-login.extract=true
```

### 配置属性说明

| 属性 | 描述 | 必填 | 示例 |
|------|------|------|------|
| apps | 应用列表，逗号分隔 | 是 | vmicro-app-main,vmicro-app-login |
| {app}.local_path | 本地存储路径 | 是 | ./html/vmicro-app-main |
| {app}.remote_url | 远程资源 URL | 是 | http://.../vmicro-app-main.zip |
| {app}.extract | 是否解压压缩文件 | 否（默认 false） | true/false |

## 工作流程

### 前端资源同步流程

1. **读取配置** - 解析 frontend-apps.properties
2. **差异检测** - 比较本地和远程文件大小
3. **下载资源** - 从 remote_url 下载压缩包到临时目录
4. **完整性校验** - SHA256 验证（如果存在.sha256 文件）
5. **备份旧版本** - 自动保留最近 3 个备份
6. **解压部署** - 解压到目标目录
7. **完成** - Nginx 下次请求自动提供新文件

### 为什么不需要 reload nginx？

Nginx 处理静态文件的机制：
- ✅ 每次 HTTP 请求都会读取磁盘上的最新文件
- ✅ 不会将文件内容缓存到内存（默认配置）
- ✅ 文件替换后立即生效，无需 reload

只有在以下情况才需要 reload：
- 修改了 nginx.conf 配置文件
- 启用了 open_file_cache 且文件被缓存
- 修改了文件权限或所有权

## 自动化集成示例

### CI/CD 流程

```bash
# 1. 前端构建并上传到文件服务器
npm run build
zip -r vmicro-app-main.zip dist/
curl -T vmicro-app-main.zip http://192.168.1.115:9000/cicd-release/frontend/vmicro-app-main/latest/

# 2. 在部署服务器上同步资源
cd /path/to/star-dockers/middleware/nginx
bash sync-frontend.sh

# 3. 验证部署
curl http://192.168.1.108/vmicro-app-main/
```

### 定时更新（Cron）

```bash
# 每天凌晨 2 点自动同步前端资源
0 2 * * * cd /path/to/middleware/nginx && bash sync-frontend.sh >> /var/log/frontend-sync.log 2>&1
```

## 备份和回滚

### 备份管理

脚本自动管理备份：
- 每次更新前自动备份旧版本
- 保留最近 3 个备份
- 备份目录命名：`{app}.backup.YYYYMMDD-HHMMSS`

### 手动回滚

```bash
# 查看备份
ls -lt html/vmicro-app-main.backup.*

# 回滚到指定版本
rm -rf html/vmicro-app-main
mv html/vmicro-app-main.backup.20260423-103000 html/vmicro-app-main

# 立即生效（无需 reload）
```

## 日志和监控

### 日志文件位置

- 前端：`middleware/nginx/frontend-sync.log`
- 后端：`microsystem/app-sync.log`

### 日志格式

```
[2026-04-23 10:30:15] === Starting frontend sync ===
[2026-04-23 10:30:15] Loaded apps: vmicro-app-main,vmicro-app-login
[2026-04-23 10:30:15] Checking vmicro-app-main...
[2026-04-23 10:30:16] Downloading new version for vmicro-app-main...
[2026-04-23 10:30:18] ✅ Extracted /tmp/tmp.XXX to ./html/vmicro-app-main
[2026-04-23 10:30:18] ✅ Updated ./html/vmicro-app-main
[2026-04-23 10:30:18] === Frontend sync completed ===
```

## 常见问题

### 1. 下载失败
**问题**: `Failed to download http://...`  
**解决**: 
- 检查网络连接
- 验证 URL 是否可访问：`curl -I <remote_url>`
- 确认文件服务器正常运行

### 2. SHA256 校验失败
**问题**: `SHA256 mismatch for <app>`  
**解决**:
- 确认.sha256 文件与资源文件匹配
- 重新生成.sha256：`sha256sum file.zip > file.zip.sha256`
- 或暂时移除.sha256 文件跳过校验

### 3. 解压失败
**问题**: 解压后目录为空或文件缺失  
**解决**:
- 检查 zip 包结构是否正确（应该直接包含应用文件，而不是嵌套目录）
- 手动测试解压：`unzip -l <file.zip>` 查看内容

### 4. 磁盘空间不足
**问题**: 备份占用过多空间  
**解决**:
- 手动清理旧备份：`rm -rf html/*.backup.*`
- 脚本已自动限制保留最近 3 个备份

## 最佳实践

1. **版本管理**: 在 remote_url 中使用版本号而非 latest，便于回滚
2. **预检查**: 生产环境更新前先执行 `--download-only` 验证
3. **备份验证**: 定期检查备份文件是否完整
4. **监控日志**: 设置日志监控告警，及时发现同步失败
5. **离线部署**: 在隔离环境中，可提前下载资源到本地服务器

## 注意事项

- ✅ 脚本需要 curl、unzip、sha256sum 工具
- ✅ 确保对 html 目录有写权限
- ✅ 生产环境建议先在测试环境验证
- ✅ 大文件下载注意超时设置（默认 300 秒）
- ✅ 文件服务器需要支持 HTTP HEAD 请求（获取文件大小）

通过这种简单独立的设计，我们实现了前端资源的自动化部署，同时避免了复杂的依赖和潜在的风险。
