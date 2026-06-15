#!/bin/sh

# ==========================================
# 1. 调试参数构建逻辑
# ==========================================
DEBUG_OPTS=""

# 检查是否定义了 JDWP_PORT 环境变量
if [ -n "${JDWP_PORT}" ]; then
    echo "=================================================="
    echo "  [DEBUG MODE] Remote Debug Enabled on Port: ${JDWP_PORT}"
    echo "  [DEBUG MODE] Suspend Mode: n (Start immediately)"
    echo "=================================================="
    # server=y: 作为调试服务端
    # suspend=n: 不挂起，应用直接启动（如果需要排查启动问题，可改为 y）
    # address=*: 监听所有网卡，允许外部连接
    DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${JDWP_PORT}"
fi

# 检查是否启用了 SkyWalking
if [ "${SKYWALKING_ENABLED:-false}" = "true" ]; then
    echo "SkyWalking enabled, starting with agent..."
    exec java ${JAVA_OPTS} \
        ${DEBUG_OPTS} \
        -javaagent:/app/toolkits/skywalking-agent/skywalking-agent.jar \
        -Dskywalking.agent.service_name=${SERVICE_NAME} \
        -Dskywalking.collector.backend_service=${SKYWALKING_BACKEND_SERVICE} \
        -Dskywalking.log_reporter.enable=true \
        -Dskywalking.agent.debug=true \
        -Dskywalking.agent.sample_n_per_3_secs=-1 \
        -Dskywalking.logging.dir=/app/logs \
        -Dlogging.file.path=/app/logs \
        -Dlogging.file.name=/app/logs/${SERVICE_NAME}.log \
	      -Dstar.env.tag= \
	      -Dstar.tenant.enable=false \
        -jar /app/${SERVICE_NAME}/app.jar
else
    echo "SkyWalking not enabled, starting without agent..."
    exec java ${JAVA_OPTS} \
         ${DEBUG_OPTS} \
        -Dlogging.file.path=/app/logs \
        -Dlogging.file.name=/app/logs/${SERVICE_NAME}.log \
	      -Dstar.env.tag= \
	      -Dstar.tenant.enable=false \
        -jar /app/${SERVICE_NAME}/app.jar
fi
