#!/bin/bash
set -euo pipefail

MAX_WAIT=120        # 最大等待秒数
POLL_INTERVAL=2    # 轮询间隔

shutdown_compose() {
  local name="$1"
  local dir="$2"

  cd "$dir"
  echo "Stopping $name..."
  docker compose down

  local elapsed=0
  while [[ $elapsed -lt $MAX_WAIT ]]; do
    local containers
    containers=$(docker compose ps -q 2>/dev/null || true)
    if [[ -z "$containers" ]]; then
      echo "✅ $name shutdown done"
      cd "${OLDPWD}"
      return 0
    fi
    sleep $POLL_INTERVAL
    elapsed=$((elapsed + POLL_INTERVAL))
  done

  echo "⚠️ Timeout: $name still has running containers:"
  docker compose ps
  cd "${OLDPWD}"
  return 1
}

shutdown_compose "Middleware" "middleware"
shutdown_compose "Microsystem" "microsystem"