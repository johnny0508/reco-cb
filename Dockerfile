# 使用更完整的基础镜像
FROM python:3.11-slim
# FROM --platform=linux/amd64 python:3.11-slim

# 设置 PYTHONPATH
ENV PYTHONPATH=/code/src

WORKDIR /code

# 先仅复制 requirements.txt 以利用 Docker 缓存
COPY requirements.txt ./

# 安装必要的系统包和 Python 包
RUN apt-get update && \
    apt-get install -y gcc musl-dev libffi-dev && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 复制 .env 文件和所有代码
COPY src/.env ./src/.env
COPY . .

EXPOSE 8001

ENTRYPOINT ["gunicorn", "--workers=5", "--threads=5", "src.app:app", "-b", ":8001"]