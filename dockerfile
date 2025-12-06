# 使用 Debian 12 (bookworm) slim 作为基础镜像
FROM debian:12-slim

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /workspace

# 安装基础依赖和工具
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 安装 Claude Code (假设通过 npm 安装)
# 注意：这里需要根据实际的 Claude Code 安装方式调整
RUN npm install -g @anthropic-ai/claude-code || echo "Claude Code installation placeholder"

# 安装 Happy CLI
# 注意：这里需要根据实际的 Happy CLI 安装方式调整
RUN pip3 install --no-cache-dir happy-cli || echo "Happy CLI installation placeholder"

# 创建工作目录
RUN mkdir -p /workspace /data

# 设置权限
RUN chmod -R 755 /workspace /data

# 暴露可能需要的端口
EXPOSE 8080 3000

# 默认命令
CMD ["/bin/bash"]
