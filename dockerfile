# 使用 Debian 12 (bookworm) slim 作为基础镜像
FROM debian:12-slim

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /data

# 安装基础依赖和工具
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 pyenv
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# 安装 Python 3.12 并设置为全局默认版本
RUN pyenv install 3.12 && \
    pyenv global 3.12 && \
    pyenv rehash

# 安装 uv (快速 Python 包管理器)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 将 uv 添加到 PATH
ENV PATH="/root/.local/bin:$PATH"

# 安装 Node.js 22.x 和 npm
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# 安装 Happy CLI
# 从 GitHub 安装 happy-coder
RUN npm install -g happy-coder

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
