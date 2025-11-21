# 使用微软官方 Playwright 镜像
# 这个镜像基于 Ubuntu 22.04，包含 Python 3.10+ 和预装的浏览器
# 它可以完美解决依赖缺失和构建失败的问题
FROM mcr.microsoft.com/playwright/python:v1.49.1-jammy

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /app

# 1. 安装 Node.js 20
# Playwright 镜像默认不带 Node.js (或者版本可能不合适)，我们需要手动装一下
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. 复制并安装 Python 依赖
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 注意：我们删除了 'RUN playwright install'
# 因为这个基础镜像里已经预装好了浏览器！

# 3. 复制项目代码
COPY . .

# 挂载点
VOLUME ["/app/data", "/app/config"]

# 入口点
ENTRYPOINT ["python", "main.py"]

# 默认命令
CMD ["--help"]