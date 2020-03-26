FROM alpine:3.10

RUN apk add -U bash keepalived

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
