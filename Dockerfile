# 使用 Python 3.9 slim 版本
FROM python:3.9-slim

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 设置工作目录
WORKDIR /app

# 1. 修改这里：安装系统依赖
# 增加了 build-essential, gcc, python3-dev, libffi-dev 等编译所需的库
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    python3-dev \
    libffi-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 2. 安装 Node.js (保持不变)
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 3. 修改这里：先升级 pip，再安装依赖
# 升级 pip 可以避免一些因为 pip 版本过低找不到二进制包而强制编译的问题
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