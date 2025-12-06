#!/bin/bash

# 容器启动入口脚本

set -e

echo "==================================="
echo "Claude Code & Happy CLI 环境启动"
echo "==================================="

# 配置 npm 源（如果设置了环境变量）
if [ -n "$NPM_REGISTRY" ]; then
    echo "配置 npm 源: $NPM_REGISTRY"
    npm config set registry "$NPM_REGISTRY"
fi

# 检查并安装/更新 Claude Code
if command -v claude &> /dev/null; then
    echo "检测到 Claude Code，正在检查更新..."
    claude update || echo "Claude Code 更新检查完成"
else
    echo "未检测到 Claude Code，正在安装..."
    echo "CLAUDE_PACKAGE 环境变量: ${CLAUDE_PACKAGE:-未设置}"
    if [ -n "$CLAUDE_PACKAGE" ]; then
        echo "开始安装: npm install -g $CLAUDE_PACKAGE"
        npm install -g "$CLAUDE_PACKAGE" && echo "Claude Code 安装成功" || echo "Claude Code 安装失败，请检查包名和网络"
    else
        echo "警告: 未设置 CLAUDE_PACKAGE 环境变量，跳过 Claude Code 安装"
        echo "请在 .env 文件中设置 CLAUDE_PACKAGE 环境变量为正确的 npm 包名"
    fi
fi

# 检查 Happy CLI
if command -v happy &> /dev/null; then
    echo "检测到 Happy CLI"
else
    echo "未检测到 Happy CLI"
fi

echo "==================================="
echo "环境准备完成"
echo "==================================="
echo ""

# 执行传入的命令，如果没有命令则启动 bash
exec "$@"
