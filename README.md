# Claude Code & Happy CLI Docker 环境

这是一个基于 Debian 12 slim 的 Docker 项目，用于安全地运行 Claude Code 和 Happy CLI 工具。通过 Docker 容器隔离，确保主机系统的安全性，同时通过目录映射实现便捷的文件访问。

## 项目特点

- **安全隔离**: 使用 Docker 容器隔离运行环境，保护主机系统
- **轻量基础**: 基于 Debian 12 slim 镜像，体积小巧
- **目录映射**: 通过 docker-compose 映射工作目录，方便文件管理
- **资源限制**: 可配置 CPU 和内存限制，防止资源滥用
- **持久化**: 配置和数据持久化保存在主机目录

## 目录结构

```
.
├── dockerfile              # Docker 镜像构建文件
├── compose.yaml            # Docker Compose 配置
├── start.sh               # 快速启动脚本
├── stop.sh                # 停止脚本
├── enter.sh               # 进入容器脚本
├── config_example.env     # 环境变量配置示例
├── workspace/             # 工作目录（映射）
├── data/                  # 数据目录（映射）
├── config/                # 配置目录（映射）
└── home/                  # Home 目录持久化（映射）
```

## 快速开始

### 前置要求

- Docker
- Docker Compose

### 1. 克隆项目

```bash
git clone <repository-url>
cd happy_cli_claude_code_docker
```

### 2. 启动环境

使用快速启动脚本：

```bash
chmod +x start.sh
./start.sh
```

或手动启动：

```bash
# 创建必要目录
mkdir -p workspace data config home

# 构建镜像
docker-compose build

# 启动容器
docker-compose up -d
```

### 3. 进入容器

使用快捷脚本：

```bash
chmod +x enter.sh
./enter.sh
```

或使用 Docker 命令：

```bash
docker exec -it claude_happy_workspace bash
```

### 4. 停止环境

```bash
chmod +x stop.sh
./stop.sh
```

或：

```bash
docker-compose down
```

## 使用说明

### 工作目录映射

- `./workspace` → `/workspace` - 主要工作目录
- `./data` → `/data` - 数据存储目录
- `./config` → `/config` - 配置文件目录
- `./home` → `/root` - 用户 home 目录（保存工具配置）

所有在容器内对这些目录的修改都会同步到主机。

### 端口映射

默认映射端口：
- `8080:8080` - Web 服务端口
- `3000:3000` - 开发服务器端口

可以在 `compose.yaml` 中根据需要修改。

### 环境变量配置

1. 复制配置示例：
```bash
cp config_example.env .env
```

2. 编辑 `.env` 文件，添加必要的配置

3. 重启容器使配置生效

### 资源限制

在 `compose.yaml` 中已配置默认资源限制：
- CPU: 最大 2 核，预留 1 核
- 内存: 最大 4GB，预留 2GB

可根据实际需求调整。

## 安全特性

1. **容器隔离**: 应用运行在独立的容器环境中
2. **资源限制**: 防止资源耗尽攻击
3. **安全选项**: 启用 `no-new-privileges` 防止权限提升
4. **网络隔离**: 使用 bridge 网络模式

## 常用命令

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

## 自定义配置

### 修改 Dockerfile

如需安装额外的工具或依赖，编辑 `dockerfile` 文件，然后重新构建：

```bash
docker-compose build --no-cache
docker-compose up -d
```

### 修改 Docker Compose 配置

编辑 `compose.yaml` 文件可以：
- 调整资源限制
- 添加新的端口映射
- 修改卷映射
- 添加环境变量

## 注意事项

1. **Claude Code 和 Happy CLI 安装**: Dockerfile 中的安装命令需要根据实际的安装方式调整
2. **API 密钥**: 如需使用 Claude API，请在 `.env` 文件中配置
3. **数据备份**: 重要数据请定期备份 `workspace`、`data` 和 `config` 目录
4. **权限问题**: 容器内以 root 用户运行，映射目录的权限可能需要调整

## 故障排查

### 容器无法启动

```bash
# 查看详细日志
docker-compose logs

# 检查 Docker 状态
docker info
```

### 权限问题

```bash
# 修改映射目录权限
chmod -R 755 workspace data config home
```

### 端口冲突

检查 `compose.yaml` 中的端口是否被占用，修改为其他可用端口。

## 贡献

欢迎提交 Issue 和 Pull Request。

## 许可证

[添加许可证信息]
