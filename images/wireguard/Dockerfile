FROM ubuntu:19.10
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
WORKDIR /wireguard

RUN apt-get update && apt-get install -y wireguard libmnl-dev libelf-dev build-essential iproute2 net-tools gcc-8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 1

ADD https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190702.tar.xz /wireguard.tar.xz
RUN tar -C /wireguard -xf /wireguard.tar.xz

ENV INTERFACE wg0

COPY start.sh /wireguard/

CMD bash --init-file start.sh
