#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAX_WAIT=600
POLL_INTERVAL=5

# 1. 先确保完全关闭
bash "$SCRIPT_DIR/shutdown.sh"

# 启动 compose
startup_compose() {
  local name="$1"
  local dir="$2"
  cd "$dir"
  echo "Starting $name..."
  docker compose up -d
  cd "${OLDPWD}"
}

# 等待指定服务 healthy
wait_healthy() {
  local dir="$1"
  local service="$2"
  cd "$dir"
  echo "Waiting for $service to become healthy..."
  local elapsed=0
  while [[ $elapsed -lt $MAX_WAIT ]]; do
    local status
    status=$(docker compose ps --format json "$service" 2>/dev/null \
      | grep -o '"Health":"[^"]*"' | head -1 | cut -d'"' -f4 || true)
    if [[ "$status" == "healthy" ]]; then
      echo "✅ $service is healthy"
      cd "${OLDPWD}"
      return 0
    fi
    sleep $POLL_INTERVAL
    elapsed=$((elapsed + POLL_INTERVAL))
  done
  echo "⚠️ Timeout: $service not healthy after ${MAX_WAIT}s"
  docker compose ps "$service"
  cd "${OLDPWD}"
  return 1
}

# 等待 compose 下所有服务 healthy
wait_all_healthy() {
  local name="$1"
  local dir="$2"
  cd "$dir"
  echo "Waiting for all $name services to become healthy..."
  local elapsed=0
  while [[ $elapsed -lt $MAX_WAIT ]]; do
    local unhealthy
    unhealthy=$(docker compose ps --format json 2>/dev/null \
      | grep -v '"Health":"healthy"' | grep -c '"Name"' || true)
    if [[ "$unhealthy" -eq 0 ]]; then
      echo "✅ All $name services are healthy"
      cd "${OLDPWD}"
      return 0
    fi
    sleep $POLL_INTERVAL
    elapsed=$((elapsed + POLL_INTERVAL))
  done
  echo "⚠️ Timeout: some $name services not healthy"
  docker compose ps
  cd "${OLDPWD}"
  return 1
}

# === 主流程 ===

# 2. 启动中间件
startup_compose "Middleware" "$SCRIPT_DIR/middleware"

# 3. 等待 nacos healthy（微服务依赖 nacos 注册）
wait_healthy "$SCRIPT_DIR/middleware" "nacos"

# 3.1 初始化 TDengine（创建 iot 数据库）
bash "$SCRIPT_DIR/middleware/tdengine/init-tdengine/init.sh"

# 4. 启动微服务
startup_compose "Microsystem" "$SCRIPT_DIR/microsystem"

# 5. 等待所有微服务 healthy
wait_all_healthy "Microsystem" "$SCRIPT_DIR/microsystem"

echo "✅ All services started and healthy"
