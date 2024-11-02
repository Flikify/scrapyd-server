# scrapyd-server
由 scrapyd 和 scrapydweb 组成的 docker 镜像。如果你只在一台机器上部署，那ta是你的选择，它可以方便迅速的将scrapyd与scrapydweb运行起来。

## 如何使用
1. 使用我构建的
```bash
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR

docker run --restart=always --name scrapy-server -itd -p 5001:5000 -p 6800:6800 \
-e SCRAPYDWEB_USERNAME=admin \
-e SCRAPYDWEB_PASSWORD=password \
-v $DIR/app/:/app \
flik007/scrapyd-server:latest

```
2. 自己构建并运行
```
docker build -t scrapy-server:latest .
docker run --restart=always --name scrapy-server -itd -p 5000:5000 -p 6800:6800 \
-e SCRAPYDWEB_USERNAME=admin \
-e SCRAPYDWEB_PASSWORD=password \
-v $DIR/app/:/app \
scrapyd-server:latest
```
