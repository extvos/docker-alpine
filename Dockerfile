FROM alpine:3
MAINTAINER "Mingcai SHEN <archsh@gmail.com>"

STOPSIGNAL SIGCONT

ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/etc/service

ENV SVDIR=${SERVICE_ENABLED_DIR} \
    SVWAIT=7

ADD https://rawgit.com/dockage/runit-scripts/master/scripts/installer /opt/

RUN apk update --no-cache && apk add --no-cache tzdata runit \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && apk del tzdata \
    && apk add  --no-cache bash curl wget ca-certificates \
    && update-ca-certificates \
    && mkdir -p ${SERVICE_AVAILABLE_DIR} ${SERVICE_ENABLED_DIR} \
    && chmod +x /opt/installer \
    && sync \
    && /opt/installer \
    && rm -rf /var/cache/apk/* /opt/installer \
    && sed -i 's/\/service/\/etc\/service/g'  \
       /etc/runit/1 /etc/runit/2 /etc/runit/3 /etc/runit/ctrlaltdel.dist /etc/runit/reboot /etc/runit/stopit

VOLUME /etc/sv
VOLUME /etc/service

# Init
ENTRYPOINT ["/sbin/runit-init"]