FROM alpine:3.20

ADD requirements.txt .
RUN apk add --update python3 python3-dev g++ py3-pip py3-ipaddress libev && \
    python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip install -r requirements.txt && \
    apk del python3-dev g++ py3-pip libev && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo '. /venv/bin/activate' >> /entrypoint.sh && \
    echo '/dockerdns "${@}"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ADD dockerdns .

EXPOSE 53
ENTRYPOINT ["/entrypoint.sh"]
