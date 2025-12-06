#!/bin/bash

# 停止脚本

set -e

echo "停止 Docker 容器..."
docker-compose down

echo ""
echo "容器已停止"
