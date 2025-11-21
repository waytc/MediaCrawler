# [关键修改 1] 使用一个已知的、较新的 VNC 镜像
FROM mcr.microsoft.com/playwright/python-vnc:v1.55.1-jammy

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

# 复制并安装 Python 依赖
COPY requirements.txt .
# [关键修改 2] 强制安装 Playwright 1.45.0 (如果你的 requirements.txt 中未指定)
# 确保 Playwright Python 库版本与项目代码兼容 (1.45.0)
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install playwright==1.45.0 --no-deps

# 复制 VNC 启动脚本并赋予权限 (vnc_entrypoint.sh)
COPY vnc_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/vnc_entrypoint.sh

# 复制项目代码
COPY . .

VOLUME ["/app/data", "/app/config"]

# [关键修改 1] ENTRYPOINT 指向 VNC 启动脚本
ENTRYPOINT ["/usr/local/bin/vnc_entrypoint.sh"]

# [关键修改 2] CMD 设置默认程序，但允许外部覆盖
# 这样，如果你不传参数，它就显示帮助。
CMD ["python", "main.py", "--help"]