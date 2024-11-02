#!/bin/bash

cleanup() {
    echo "开始清理进程..."
    pkill -P $$ || true
    pkill -f scrapyd || true
    pkill -f logparser || true
    pkill -f scrapydweb || true
    rm -f /var/run/*.pid
    echo "清理完成"
}

trap cleanup EXIT

# 检查端口
check_port() {
    local port="$1"
    if lsof -i :$port > /dev/null 2>&1; then
        echo "端口 $port 已被占用，尝试清理..."
        fuser -k $port/tcp || true
        sleep 1
    fi
}

# 检查服务就绪
wait_for_service() {
    local host="$1"
    local port="$2"
    local service="$3"
    local max_attempts=30
    local attempt=1
    
    echo "等待 $service 就绪..."
    while ! nc -z "$host" "$port"; do
        if [ $attempt -ge $max_attempts ]; then
            echo "$service 在 $((max_attempts * 2)) 秒后仍未就绪"
            exit 1
        fi
        echo "尝试 $attempt: $service 未就绪. 等待中..."
        sleep 2
        attempt=$((attempt + 1))
    done
    echo "$service 已就绪!"
}

# 初始化配置
init_config() {
    # 如果挂载的配置目录为空，复制默认配置
    if [ ! -f "/app/config/scrapyd.conf" ]; then
        cp /app/config/scrapyd.conf.default /app/config/scrapyd.conf
    fi
    if [ ! -f "/app/config/scrapydweb_settings_v10.py" ]; then
        cp /app/config/scrapydweb_settings_v10.py.default /app/config/scrapydweb_settings_v10.py
    fi
}

mkdir /app/scrapyd/project

# 检查并清理端口
check_port 6800
check_port 5000

# 初始化配置
init_config

# 配置用户名和密码
if [ ! -z "$SCRAPYD_USERNAME" ] && [ ! -z "$SCRAPYD_PASSWORD" ]; then
    sed -i "s/^username =.*/username = $SCRAPYD_USERNAME/" /app/config/scrapyd.conf
    sed -i "s/^password =.*/password = $SCRAPYD_PASSWORD/" /app/config/scrapyd.conf
fi

echo "启动服务..."

# 启动 Scrapyd
cd /app/config
scrapyd &
SCRAPYD_PID=$!

# 等待 Scrapyd 启动
wait_for_service "127.0.0.1" "6800" "Scrapyd"

# 启动 ScrapyWeb
scrapydweb &
SCRAPYWEB_PID=$!

echo "所有服务已启动"
echo "Scrapyd PID: $SCRAPYD_PID"
echo "ScrapyWeb PID: $SCRAPYWEB_PID"

# 等待任意子进程退出
wait -n

# 如果任意进程退出，清理并退出
exit 1