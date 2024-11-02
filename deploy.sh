#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# 确保目录存在
mkdir -p "$DIR/config" "$DIR/scrapyd"/{eggs,items,logs,dbs}

docker run -d --name=test \
  -p 6800:6800 \
  -p 5000:5000 \
  -e SCRAPYD_USERNAME=admin \
  -e SCRAPYD_PASSWORD=password \
  -v "$DIR/config":/app/config \
  -v "$DIR/scrapyd":/app/scrapyd \
  scrapyd-scrapyweb
