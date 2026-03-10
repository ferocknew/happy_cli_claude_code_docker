# 使用 Debian 12 (bookworm) slim 作为基础镜像
FROM debian:12-slim

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /data

# 安装基础依赖和工具（移除编译相关依赖）
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    ca-certificates \
    gnupg \
    lsb-release \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 3.12（使用系统包管理器，预编译版本）
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python

# 安装 uv (快速 Python 包管理器)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 将 uv 添加到 PATH
ENV PATH="/root/.local/bin:$PATH"

# 安装 nvm 和 Node.js 22.x
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    nvm use 22 && \
    nvm alias default 22 && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    npm install -g npm && \
    npm install -g happy-coder@0.14.0-0 && \
    npm install -g @slopus/agent@0.1.0

# 将 Node.js 添加到 PATH（使用 nvm 安装的 Node.js 路径）
ENV PATH="$NVM_DIR/versions/node/v22.12.0/bin:$PATH"

# 创建工作目录和 Claude Code 目录
RUN mkdir -p /data /root/.claude

# 设置权限
RUN chmod -R 755 /data

# 复制启动脚本
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 设置启动脚本
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# 默认命令
CMD ["/bin/bash"]
