#!/bin/bash

# 版本更新脚本
# 用法: ./update-version.sh <happy-coder-version> [@slopus/agent-version]
# 示例: ./update-version.sh 0.14.0-0 0.1.0

set -e

HAPPY_CODER_VERSION=$1
AGENT_VERSION=${2:-$(npm view @slopus/agent version 2>/dev/null)}

if [ -z "$HAPPY_CODER_VERSION" ]; then
    echo "用法: $0 <happy-coder-version> [@slopus/agent-version]"
    echo ""
    echo "示例:"
    echo "  $0 0.14.0-0           # 只更新 happy-coder 版本"
    echo "  $0 0.14.0-0 0.1.0      # 同时更新两个版本"
    echo ""
    echo "当前 happy-coder 最新版本:"
    npm view happy-coder version 2>/dev/null || echo "无法获取"
    echo ""
    echo "当前 @slopus/agent 最新版本:"
    npm view @slopus/agent version 2>/dev/null || echo "无法获取"
    exit 1
fi

# 验证版本是否存在
echo "验证版本..."
if ! npm view happy-coder@$HAPPY_CODER_VERSION version &>/dev/null; then
    echo "错误: happy-coder@$HAPPY_CODER_VERSION 不存在"
    exit 1
fi

if ! npm view @slopus/agent@$AGENT_VERSION version &>/dev/null; then
    echo "错误: @slopus/agent@$AGENT_VERSION 不存在"
    exit 1
fi

echo "✅ 版本验证通过"
echo "  - happy-coder: $HAPPY_CODER_VERSION"
echo "  - @slopus/agent: $AGENT_VERSION"
echo ""

# 更新 dockerfile
echo "更新 dockerfile..."
sed -i '' "s|happy-coder@.*|happy-coder@$HAPPY_CODER_VERSION|" dockerfile
sed -i '' "s|@slopus/agent@.*|@slopus/agent@$AGENT_VERSION|" dockerfile

# 更新 compose.yaml
echo "更新 compose.yaml..."
sed -i '' "s|happy_cli_claude_code_docker:.*|happy_cli_claude_code_docker:$HAPPY_CODER_VERSION|" compose.yaml

echo ""
echo "✅ 更新完成!"
echo ""
echo "下一步操作:"
echo "  1. 检查修改: git diff"
echo "  2. 提交修改: git add . && git commit -m 'build: update to happy-coder@$HAPPY_CODER_VERSION'"
echo "  3. 创建标签: git tag v$HAPPY_CODER_VERSION"
echo "  4. 推送: git push origin main --tags"
