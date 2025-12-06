#!/bin/bash

# 容器启动入口脚本

set -e

echo "==================================="
echo "Claude Code & Happy CLI 环境启动"
echo "==================================="

# 检查并自动更新 Claude Code
if command -v claude &> /dev/null; then
    echo "检测到 Claude Code，正在检查更新..."
    claude update || echo "Claude Code 更新检查完成"
else
    echo "未检测到 Claude Code"
fi

# 检查并自动更新 Happy CLI
if command -v happy &> /dev/null; then
    echo "检测到 Happy CLI"
    # 如果有更新命令，可以在这里添加
    # npm update -g happy-coder
else
    echo "未检测到 Happy CLI"
fi

echo "==================================="
echo "环境准备完成"
echo "==================================="
echo ""

# 执行传入的命令，如果没有命令则启动 bash
exec "$@"
