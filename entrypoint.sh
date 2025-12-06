#!/bin/bash

# 容器启动入口脚本

set -e

# 加载 nvm 环境
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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

# 替换 settings.json 中的环境变量占位符
if [ -f /root/.claude/settings.json ]; then
    echo "配置 Claude Code settings.json..."
    # 使用 envsubst 替换环境变量（如果可用）
    if command -v envsubst &> /dev/null; then
        envsubst < /root/.claude/settings.json > /root/.claude/settings.json.tmp
        mv /root/.claude/settings.json.tmp /root/.claude/settings.json
    else
        # 手动替换环境变量
        if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then
            sed -i "s|\${ANTHROPIC_AUTH_TOKEN}|$ANTHROPIC_AUTH_TOKEN|g" /root/.claude/settings.json
        fi
        if [ -n "$ANTHROPIC_BASE_URL" ]; then
            sed -i "s|\${ANTHROPIC_BASE_URL}|$ANTHROPIC_BASE_URL|g" /root/.claude/settings.json
        fi
    fi
    echo "Claude Code 配置完成"
fi

# 如果没有传入命令，则在 data 目录启动 Happy CLI
if [ $# -eq 0 ] || [ "$1" = "/bin/bash" ]; then
    cd /data
    
    # 检查 Happy CLI 是否存在
    if command -v happy &> /dev/null; then
        echo "启动 Happy CLI 在 /data 目录..."
        # 设置 HAPPY_SERVER_URL 环境变量
        if [ -n "$HAPPY_SERVER_URL" ]; then
            echo "HAPPY_SERVER_URL: $HAPPY_SERVER_URL"
            export HAPPY_SERVER_URL
        fi
        exec happy
    else
        echo "Happy CLI 未安装，启动 bash..."
        exec /bin/bash
    fi
else
    # 执行传入的命令
    exec "$@"
fi
