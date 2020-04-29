FROM alpine:3.11
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
WORKDIR /wireguard

RUN apk add wireguard-tools

ENV INTERFACE wg0

COPY start.sh /wireguard/

CMD bash --init-file start.sh
