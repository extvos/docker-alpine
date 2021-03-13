FROM alpine:3
MAINTAINER "Mingcai SHEN <archsh@gmail.com>"

RUN apk update --no-cache && apk add --no-cache tzdata runit \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && apk del tzdata \
    && apk add  --no-cache bash curl wget ca-certificates update-ca-certificates

# Init
ENTRYPOINT [ "/sbin/runit-init" ]