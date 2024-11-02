FROM python:3.9-slim

ENV SCRAPYDWEB_USERNAME=admin
ENV SCRAPYDWEB_PASSWORD=password

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    netcat-traditional \
    lsof \
    procps \
    && rm -rf /var/lib/apt/lists/*

# 创建必要的目录结构
RUN mkdir -p /app/config \
    /app/scrapyd/{eggs,items,logs,dbs,project}

# 安装依赖
RUN pip3 install --no-cache-dir scrapydweb scrapyd scrapy logparser scrapy-redis

# 复制配置文件（这些将作为默认配置）
COPY config/scrapyd.conf /app/config/
COPY config/scrapydweb_settings_v10.py /app/config/
COPY run.sh /usr/bin/

EXPOSE 5000 6800

RUN chmod +x /usr/bin/run.sh

ENTRYPOINT ["/usr/bin/run.sh"]