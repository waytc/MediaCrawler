# [修改这里] 使用带 VNC 的 Playwright 镜像，版本依然匹配 1.45.0
FROM mcr.microsoft.com/playwright/python-vnc:v1.45.0-jammy

# 下面的内容保持不变
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# 安装 Node.js 20
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

VOLUME ["/app/data", "/app/config"]

# [关键修改 1] ENTRYPOINT 指向 VNC 启动脚本
ENTRYPOINT ["/usr/local/bin/vnc_entrypoint.sh"]

# [关键修改 2] CMD 设置默认程序，但允许外部覆盖
# 这样，如果你不传参数，它就显示帮助。
CMD ["python", "main.py", "--help"]