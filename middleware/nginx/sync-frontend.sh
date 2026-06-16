#!/bin/bash
set -euo pipefail

# 参数解析
# 用法: bash ./sync-frontend.sh [--download-only]
DOWNLOAD_ONLY=false
if [[ "${1:-}" == "--download-only" ]]; then
  DOWNLOAD_ONLY=true
fi

# ======================
# 配置区
# ======================
CONFIG_FILE="./frontend-apps.properties"
LOG_FILE="./frontend-sync.log"

# 记录日志函数
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# ======================
# 主逻辑
# ======================
log "=== Starting frontend sync ==="

# 检查依赖
command -v curl >/dev/null || { log "Error: curl not installed"; exit 1; }
command -v unzip >/dev/null || { log "Error: unzip not installed"; exit 1; }
command -v sha256sum >/dev/null || { log "Error: sha256sum not installed"; exit 1; }

# 临时目录
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# ======================
# 解析 properties 文件
# ======================
declare -A APP_CONFIG
APPS_LIST=""

while IFS='=' read -r key value; do
  [[ -z "$key" ]] && continue
  [[ "$key" =~ ^[[:space:]]*# ]] && continue

  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)

  if [[ "$key" == "apps" ]]; then
    APPS_LIST="$value"
  else
    APP_CONFIG["$key"]="$value"
  fi
done < "$CONFIG_FILE"

log "Loaded apps: $APPS_LIST"
for k in "${!APP_CONFIG[@]}"; do
  log "Config[$k] = ${APP_CONFIG[$k]}"
done

if [[ -z "$APPS_LIST" ]]; then
  log "No frontend apps configured. Skip download."
  exit 0
fi

# 拆分应用列表
IFS=',' read -ra APP_NAMES <<< "$APPS_LIST"

# ======================
# 主循环
# ======================
for app_name in "${APP_NAMES[@]}"; do
  app_name=$(echo "$app_name" | xargs)
  [[ -z "$app_name" ]] && continue

  log "Checking $app_name..."

  local_path_key="${app_name}.local_path"
  remote_url_key="${app_name}.remote_url"

  if [[ -z "${APP_CONFIG[$local_path_key]+x}" ]] || [[ -z "${APP_CONFIG[$remote_url_key]+x}" ]]; then
    log "❌ Missing config for $app_name"
    continue
  fi

  local_path="${APP_CONFIG[$local_path_key]}"
  remote_url="${APP_CONFIG[$remote_url_key]}"

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
    tmp_file="$TMP_DIR/${app_name}.zip.tmp"

    if ! curl -sfL "$remote_url" -o "$tmp_file"; then
      log "❌ Failed to download $remote_url"
      continue
    fi

    # 校验 SHA256
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

    # 替换 zip 文件
    mv "$tmp_file" "$local_path"
    log "✅ Updated $local_path"

    # 删除旧解压目录，再解压，确保完全覆盖
    extract_dir=$(dirname "$local_path")/$(basename "${local_path%.zip}")
    if [[ -d "$extract_dir" ]]; then
      rm -rf "$extract_dir"
      log "Removed old directory: $extract_dir"
    fi

    if ! unzip -o "$local_path" -d "$(dirname "$local_path")"; then
      log "❌ Failed to unzip $local_path"
      continue
    fi
    log "✅ Extracted to $(dirname "$local_path")"
  else
    log "✅ $app_name is up-to-date (size: $local_size)"
  fi

done

log "=== Sync completed ==="
