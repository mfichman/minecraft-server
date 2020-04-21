FROM debian

MAINTAINER Matt Fichman <matt.fichman@gmail.com>

ARG URL=https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar

# Install apt dependencies
COPY minecraft/packages.txt /minecraft/packages.txt
RUN apt-get update -y && apt-get install -y `cat /minecraft/packages.txt`
RUN update-alternatives --display java

COPY minecraft/requirements.txt /minecraft/requirements.txt
RUN pip install -r /minecraft/requirements.txt
RUN curl -sL $URL > /minecraft/minecraft_server.jar

COPY minecraft /minecraft

VOLUME /data

EXPOSE 443 25565
CMD bash /minecraft/launcher.sh
