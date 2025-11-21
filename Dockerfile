# 核心修改：将基础镜像从 3.9 升级到 3.11-slim，以满足 xhshow 的依赖要求
FROM python:3.11-slim

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    # 设置 Playwright 浏览器路径
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 设置工作目录
WORKDIR /app

# 安装系统依赖 (包含编译工具 build-essential 等)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    python3-dev \
    libffi-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 安装 Node.js 20
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装 Python 依赖
# 升级 pip 并安装依赖
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 安装 Playwright 浏览器
RUN playwright install --with-deps chromium

# 复制项目代码
COPY . .

# 挂载点
VOLUME ["/app/data", "/app/config"]

# 入口点
ENTRYPOINT ["python", "main.py"]

# 默认命令
CMD ["--help"]