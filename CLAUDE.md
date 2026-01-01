# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 Docker 项目，为 Claude Code 和 Happy CLI 提供隔离的运行环境。基于 Debian 12 slim，包含 Python 3.12、Node.js 22.x、uv 包管理器和必要的开发工具。

## 核心架构

- **容器化环境**: 使用 Docker Compose 管理服务，确保开发和生产环境的一致性
- **目录映射**:
  - `./data` → `/data` - 主要工作目录
  - `./data/.claude` → `/root/.claude` - Claude Code 配置
  - `./data/.happy` → `/root/.happy` - Happy CLI 配置
- **工具链**: 集成 pyenv (Python 3.12)、nvm (Node.js 22.x)、uv (Python 包管理器)

## 常用命令

### 环境管理
```bash
# 启动环境
./start.sh

# 进入容器
docker exec -it claude_happy_workspace bash
# 或
./enter.sh

# 停止环境
./stop.sh
# 或
docker-compose down

# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 开发命令
```bash
# 重新构建镜像
docker-compose build --no-cache

# 重启容器
docker-compose restart

# 在容器内运行 Claude Code
docker exec -it claude_happy_workspace claude

# 在容器内运行 Happy CLI
docker exec -it claude_happy_workspace happy
```

## 配置管理

### 环境变量
- 复制 `config_example.env` 为 `.env` 并修改配置
- 支持 Claude API 和智谱 API 配置
- 可配置 npm 源（官方源/淘宝源/私服）

### Claude Code 配置
- 主配置文件: `data/.claude.json`
- 设置文件: `data/.claude/settings.json`
- 支持环境变量替换（ANTHROPIC_AUTH_TOKEN, ANTHROPIC_BASE_URL）

## 项目特点

1. **安全隔离**: 启用 `no-new-privileges`，资源限制（CPU: 2核, 内存: 4GB）
2. **持久化存储**: 配置和数据通过卷映射持久化到主机
3. **自动化安装**: 容器启动时自动检查和安装 Claude Code
4. **多包管理**: 支持 npm（Node.js）和 uv（Python）

## 开发注意事项

- 所有工作应在 `/data` 目录进行，该目录映射到主机的 `./data`
- Claude Code 配置会自动从环境变量加载 API 密钥
- 容器默认以 root 用户运行，注意文件权限问题
- 日志限制为 20MB，保留 3 个文件