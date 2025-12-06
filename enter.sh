#!/bin/bash

# 进入容器的快捷脚本

set -e

echo "进入 Claude Happy 工作环境..."
docker exec -it claude_happy_workspace bash
