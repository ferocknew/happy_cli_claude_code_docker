# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Debian 12 slim 的 Docker 项目，用于安全地运行 Claude Code 和 Happy CLI 工具。项目通过 Docker 容器隔离确保主机系统安全性，同时通过目录映射实现便捷的文件访问和配置管理。

## 常用命令

### 启动和停止

```bash
# 快速启动（推荐）
./start.sh

# 手动启动
mkdir -p data data/.claude data/.happy
docker-compose build
docker-compose up -d

# 进入容器
./enter.sh
# 或
docker exec -it claude_happy_workspace bash

# 停止容器
./stop.sh
# 或
docker-compose down
```

### Docker 操作

```bash
# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 重启容器
docker-compose restart

# 重新构建镜像
docker-compose build --no-cache

# 清理所有数据（谨慎使用）
docker-compose down -v
```

### 容器内工具

```bash
# 检查 Claude Code 版本
claude --version

# 更新 Claude Code
claude update

# 运行 Happy CLI（在 /data 目录）
cd /data
happy

# Python 环境（通过 pyenv 管理）
python --version

# Node.js 环境（通过 nvm 管理）
node --version
npm --version
```

## 架构说明

### 核心组件

1. **dockerfile**: 基于 Debian 12 slim 构建，包含：
   - Python 3.12（通过 pyenv 安装）
   - Node.js 22.x（通过 nvm 安装）
   - uv（快速 Python 包管理器）
   - Happy CLI（全局安装的 npm 包）
   - Claude Code（通过环境变量配置的 npm 包）

2. **compose.yaml**: Docker Compose 配置
   - 容器名：`claude_happy_workspace`
   - 镜像：`happy/happy_cli_claude_code_docker:251206.8`
   - 网络模式：bridge
   - 资源限制：CPU 最大 2 核，内存最大 4GB
   - 安全选项：`no-new-privileges:true`

3. **entrypoint.sh**: 容器启动入口脚本
   - 自动检查并安装/更新 Claude Code
   - 配置 npm 源
   - 替换 settings.json 中的环境变量占位符
   - 默认在 /data 目录启动 Happy CLI

### 目录映射

- `./data` → `/data` - 主要工作目录和存储
- `./data/.claude` → `/root/.claude` - Claude Code 配置
- `./data/.claude.json` → `/root/.claude.json` - Claude Code 项目配置
- `./data/.happy` → `/root/.happy` - Happy CLI 配置

### 配置文件

1. **.env** - 环境变量配置（需手动创建，参考 config_example.env）
   - `TZ`: 时区设置（默认 Asia/Shanghai）
   - `WORKSPACE`: 工作目录（默认 /data）
   - `NPM_REGISTRY`: npm 源（默认淘宝源）
   - `DOCKER_REGISTRY`: Docker 私服地址
   - `CLAUDE_PACKAGE`: Claude Code 包名（默认 @anthropic-ai/claude-code）
   - `ANTHROPIC_AUTH_TOKEN`: Claude API 密钥
   - `ANTHROPIC_BASE_URL`: Claude API 基础 URL
   - `HAPPY_SERVER_URL`: Happy CLI 服务器地址

2. **data/.claude/settings.json** - Claude Code 设置
   - 包含环境变量占位符（如 `${ANTHROPIC_AUTH_TOKEN}`）
   - 在容器启动时由 entrypoint.sh 自动替换

3. **data/.claude.json** - Claude Code 项目配置
   - 包含项目路径、MCP 服务器配置、权限设置等

### 环境配置流程

1. 首次运行 `./start.sh` 时：
   - 创建必要的目录结构
   - 构建 Docker 镜像
   - 启动容器

2. 容器启动时（entrypoint.sh）：
   - 加载 nvm 环境
   - 配置 npm 源
   - 检查并安装/更新 Claude Code
   - 检查 Happy CLI
   - 替换 settings.json 中的环境变量
   - 在 /data 目录启动 Happy CLI

### 版本管理

- Python: 3.12（通过 pyenv 管理）
- Node.js: 22.12.0（通过 nvm 管理）
- uv: 最新版（通过官方安装脚本）
- Happy CLI: 通过 npm 全局安装
- Claude Code: 通过环境变量 `CLAUDE_PACKAGE` 指定

## 开发注意事项

### 环境变量

所有敏感配置（API 密钥、服务器地址等）应通过 .env 文件配置，该文件已被 git 忽略。

### 容器内操作

- 默认工作目录是 `/data`
- 所有对映射目录的修改会同步到主机
- 容器以 root 用户运行

### 日志管理

Docker 日志配置：
- 驱动：json-file
- 最大大小：20MB
- 最大文件数：3

### 资源限制

默认资源限制可在 compose.yaml 中调整：
- CPU 限制：2 核
- 内存限制：4GB
- CPU 预留：1 核
- 内存预留：2GB

### 镜像构建

如需修改 Dockerfile：
```bash
docker-compose build --no-cache
docker-compose up -d
```

### 故障排查

- 查看日志：`docker-compose logs -f`
- 检查容器状态：`docker-compose ps`
- 进入容器调试：`docker exec -it claude_happy_workspace bash`
- 权限问题：检查映射目录权限
- 端口冲突：检查 compose.yaml 中的端口映射

### 配置持久化

以下目录和文件会被持久化到主机：
- `data/` - 主要数据和配置
- `data/.claude/` - Claude Code 配置目录
- `data/.happy/` - Happy CLI 配置目录
- `data/.claude.json` - Claude Code 项目配置