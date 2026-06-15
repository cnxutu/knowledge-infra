#!/bin/bash

rm -rf rocketmq/data
rm -rf emqx/data
rm -rf emqx/log

mkdir -p rocketmq/data/broker/logs
mkdir -p rocketmq/data/broker/store
mkdir -p rocketmq/data/namesrv/logs
chmod -R 777 rocketmq/data  # 确保容器内用户可写

mkdir -p emqx/data
mkdir -p emqx/log
chmod -R 777 emqx/data
chmod -R 777 emqx/log

# cd nginx
# bash ./unzip_html.sh
# echo "Unzip html done"
# cd ../
