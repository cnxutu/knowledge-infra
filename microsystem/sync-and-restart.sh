#!/bin/bash
set -euo pipefail

# 参数解析
# 用法: bash ./sync-and-restart.sh [--download-only]
DOWNLOAD_ONLY=false
if [[ "${1:-}" == "--download-only" ]]; then
  DOWNLOAD_ONLY=true
fi

# ======================
# 配置区
# ======================
CONFIG_FILE="./apps.properties"   # ← 改成 .properties（或保留 .yml 但内容是 properties）
DOCKER_COMPOSE_DIR="."
LOG_FILE="./app-sync.log"

# 记录日志函数
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# 重启容器的函数（按容器名）—— 保持不变
restart_container() {
  local app_name="$1"
  local compose_file="$DOCKER_COMPOSE_DIR/docker-compose.yml"

  if [[ -f "$compose_file" ]] && command -v docker-compose >/dev/null; then
    if grep -q "container_name.*$app_name" "$compose_file" 2>/dev/null; then
      log "Restarting via docker-compose for $app_name"
      (
        cd "$DOCKER_COMPOSE_DIR"
        docker compose down "$app_name"
        sleep 2
        docker compose up -d "$app_name"
      )
      return 0
    fi
  fi

  log "⚠️ No container named '$app_name' found in docker-compose.yml"
}

# ======================
# 主逻辑
# ======================
log "=== Starting application sync ==="

# 检查依赖（移除 yq 检查）
command -v curl >/dev/null || { log "Error: curl not installed"; exit 1; }
command -v sha256sum >/dev/null || { log "Error: sha256sum not installed"; exit 1; }

# 临时目录
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# ======================
# 【关键修改】用 Bash 解析 properties 文件
# ======================
declare -A APP_CONFIG
APPS_LIST=""

while IFS='=' read -r key value; do
  # 跳过空行和注释
  [[ -z "$key" ]] && continue
  [[ "$key" =~ ^[[:space:]]*# ]] && continue

  # 去除前后空格
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)

  if [[ "$key" == "apps" ]]; then
    APPS_LIST="$value"
  else
    APP_CONFIG["$key"]="$value"
  fi
done < "$CONFIG_FILE"

# 在解析完配置后加：
log "Loaded apps: $APPS_LIST"
for k in "${!APP_CONFIG[@]}"; do
  log "Config[$k] = ${APP_CONFIG[$k]}"
done

# 拆分应用列表
IFS=',' read -ra APP_NAMES <<< "$APPS_LIST"

# ======================
# 主循环（保持不变）
# ======================
for app_name in "${APP_NAMES[@]}"; do
  app_name=$(echo "$app_name" | xargs)  # 去除可能的空格
  [[ -z "$app_name" ]] && continue

  log "Checking $app_name..."

  local_path_key="${app_name}.local_path"
  remote_url_key="${app_name}.remote_url"

  log "Local path: ${APP_CONFIG[$local_path_key]}"
  log "Remote URL: ${APP_CONFIG[$remote_url_key]}"

  if [[ -z "${APP_CONFIG[$local_path_key]+x}" ]] || [[ -z "${APP_CONFIG[$remote_url_key]+x}" ]]; then
    log "❌ Missing config for $app_name"
    continue
  fi

  local_path="${APP_CONFIG[$local_path_key]}"
  remote_url="${APP_CONFIG[$remote_url_key]}"   # ← 这里也必须加 $

  # 创建本地目录
  mkdir -p "$(dirname "$local_path")"

  # 获取远程文件大小
  if ! remote_size=$(curl -sI "$remote_url" | grep -i "^content-length:" | awk '{print $2}' | tr -d '\r'); then
    log "❌ Failed to get remote size for $app_name from $remote_url"
    continue
  fi

  local_size=""
  if [[ -f "$local_path" ]]; then
    local_size=$(stat -c%s "$local_path")
  fi

  # 快速判断：大小不同 → 需要更新
  if [[ "$local_size" != "$remote_size" ]]; then
    log "Size differs (local: $local_size, remote: $remote_size). Downloading new version..."
    tmp_file="$TMP_DIR/${app_name}.jar.tmp"

    if ! curl -sfL "$remote_url" -o "$tmp_file"; then
      log "❌ Failed to download $remote_url"
      continue
    fi

    # 校验 SHA256（可选）
    remote_sha=$(curl -sfL "${remote_url}.sha256" 2>/dev/null || echo "")
    if [[ -n "$remote_sha" ]]; then
      local_sha=$(sha256sum "$tmp_file" | cut -d' ' -f1)
      if [[ "$local_sha" != "$remote_sha" ]]; then
        log "❌ SHA256 mismatch for $app_name"
        continue
      fi
    fi

    # 备份旧文件
    if [[ -f "$local_path" ]]; then
      cp "$local_path" "${local_path}.bak.$(date +%Y%m%d-%H%M%S)"
    fi

    # 替换
    mv "$tmp_file" "$local_path"
    log "✅ Updated $local_path"

    # 重启服务（如果非下载模式）
    if [[ "$DOWNLOAD_ONLY" == "false" ]]; then
      restart_container "$app_name"
    fi
  else
    log "✅ $app_name is up-to-date (size: $local_size)"
  fi

done

log "=== Sync completed ==="
