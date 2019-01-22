FROM alpine
LABEL author Siyuan Gao <siyuangao@gmail.com>

RUN echo "http://dl-3.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories &&\
    apk update && \
    apk add \
    openjdk8-jre-base \
    openssl \
    imagemagick \
    lsof \
    unzip \
    su-exec \
    bash \
    git \
    jq &&\
    rm -rf /var/cache/apk/*

RUN addgroup -g 1000 minecraft \
    && adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft \
    && mkdir /minecraft \
    && chown minecraft:minecraft /home/minecraft /minecraft

EXPOSE 25565
VOLUME ["/minecraft"]
WORKDIR /minecraft
COPY skyfactory/start.sh /start
COPY skyfactory/server.properties /tmp/server.properties
ENTRYPOINT [ "/start" ]
