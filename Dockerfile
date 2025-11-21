# [修改这里] 将版本从 v1.49.1 改为 v1.45.0-jammy
FROM mcr.microsoft.com/playwright/python:v1.45.0-jammy

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

ENTRYPOINT ["python", "main.py"]
CMD ["--help"]