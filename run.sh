#!/bin/bash

DIR_PATH="/app"

if [ ! -d "$DIR_PATH" ] || [ ! "$(ls -A $DIR_PATH)" ]; then
    echo "File missing, initializing..."
    mv /apptemp/* /app
fi

CONFIG_FILE="/app/scrapyd.conf"

# 检查配置文件是否已经存在并包含有效信息
if [ -f "$CONFIG_FILE" ] && grep -q "username" "$CONFIG_FILE" && grep -q "password" "$CONFIG_FILE"; then
  echo "Configuration file already exists, skipping creation."
else
  # 如果配置文件不存在或不完整，生成新配置文件
  echo "Generating new configuration file..."

  USERNAME=${SCRAPYDWEB_USERNAME:-admin}
  PASSWORD=${SCRAPYDWEB_PASSWORD:-password}

  echo "username=$USERNAME" >>"$CONFIG_FILE"
  echo "password=$PASSWORD" >> "$CONFIG_FILE"
fi

cd /app
scrapyd &
echo "Wait 5 seconds..."
sleep 5
logparser &
sleep 5
scrapydweb
