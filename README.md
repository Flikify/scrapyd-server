[中文版本](./README_CN.md)
# scrapyd-server
A docker image consisting of scrapyd and scrapydweb. If you only deploy on one machine, then it is your choice. It can easily and quickly run scrapyd and scrapydweb.

## How to use
1. Using the one I have built
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
2. Build it yourself And Run
  ```
  docker build --restart=always -t scrapy-server:latest .
  docker run --name scrapy-server -itd -p 5000:5000 -p 6800:6800 \
  -e SCRAPYDWEB_USERNAME=admin \
  -e SCRAPYDWEB_PASSWORD=password \
  -v $DIR/app/:/app \
  scrapyd-server:latest
  ```