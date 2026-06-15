#!/bin/bash

# 初始化 RocketMQ Topic 的运维脚本（适用于 Docker 部署）
# 作者：运维助手
# 用法：./init-rocketmq-topics.sh

set -e  # 遇错退出

# ====== 配置区（根据实际环境修改）======
BROKER_CONTAINER_NAME="local-rocketmq-namesrv"        # Broker 容器名
NAMESRV_ADDR="192.168.1.108:9876"              # NameServer 地址（对 Broker 容器内部可见）
CLUSTER_NAME="DefaultCluster"            # 集群名称

# 要创建的 Topic 列表（每行一个，格式：topic_name queue_nums）
# 格式：TOPIC_NAME:QUEUE_COUNT （默认队列数为4）
declare -A TOPICS=(
    ["OrderTopic"]=8
    ["UserEventTopic"]=4
    ["NotificationTopic"]=6
    ["LogTopic"]=4
)

# ====== 脚本逻辑 ======
echo "🚀 开始初始化 RocketMQ Topics..."

for topic in "${!TOPICS[@]}"; do
    queue_num=${TOPICS[$topic]}
    echo "👉 创建 Topic: $topic (队列数: $queue_num)"

    # 在 Broker 容器内执行 mqadmin 命令
    docker exec "$BROKER_CONTAINER_NAME" \
        sh -c "/home/rocketmq/rocketmq-5.1.4/bin/mqadmin updateTopic \
            -n $NAMESRV_ADDR \
            -t '$topic' \
            -c '$CLUSTER_NAME' \
            -r $queue_num \
            -w $queue_num" || {
        echo "❌ 创建 Topic '$topic' 失败！"
        continue
    }

    echo "✅ Topic '$topic' 创建成功！"
done

echo "🎉 所有 Topic 初始化完成！"
