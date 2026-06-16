#!/bin/bash
set -euo pipefail

mkdir -p mysql/data mysql/log
mkdir -p redis/data redis/logs redis/conf
mkdir -p nacos/data nacos/logs
mkdir -p elasticsearch/data
mkdir -p nginx/html nginx/log
mkdir -p rocketmq/data/broker/logs rocketmq/data/broker/store rocketmq/data/namesrv/logs

chmod -R 777 mysql/data mysql/log redis/data redis/logs nacos/data nacos/logs elasticsearch/data nginx/log rocketmq/data
