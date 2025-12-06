#!/bin/bash

# 启动脚本 - 用于快速启动 Docker 环境

set -e

echo "==================================="
echo "Claude Code & Happy CLI Docker 环境"
echo "==================================="
echo ""

# 创建必要的目录
echo "创建必要的目录..."
mkdir -p workspace data config home

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "错误: Docker 未运行，请先启动 Docker"
    exit 1
fi

# 构建并启动容器
echo "构建 Docker 镜像..."
docker-compose build

echo ""
echo "启动容器..."
docker-compose up -d

echo ""
echo "==================================="
echo "容器已启动！"
echo "==================================="
echo ""
echo "使用以下命令进入容器："
echo "  docker-compose exec claude-happy-env bash"
echo ""
echo "或者使用："
echo "  docker exec -it claude_happy_workspace bash"
echo ""
echo "查看日志："
echo "  docker-compose logs -f"
echo ""
echo "停止容器："
echo "  docker-compose down"
echo ""
