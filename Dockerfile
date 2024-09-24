FROM debian:bullseye-slim

ENV SCRAPYDWEB_USERNAME=admin
ENV SCRAPYDWEB_PASSWORD=password

RUN mkdir -p /app /apptemp

WORKDIR /app

VOLUME /app

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    git \
    apache2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir scrapydweb scrapyd scrapy logparser

COPY scrapyd.conf /apptemp/scrapyd.conf

COPY run.sh /usr/bin/run.sh

COPY scrapydweb_settings_v10.py /apptemp/scrapydweb_settings_v10.py

RUN chmod +x /usr/bin/run.sh

EXPOSE 5000 6800

CMD ["/usr/bin/run.sh"]
