FROM alpine:3.11
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
WORKDIR /minecraft

RUN apk add openjdk11-jre

ARG SERVER_JAR_URL=https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
ADD $SERVER_JAR_URL /minecraft/minecraft_server.jar
COPY . /minecraft

VOLUME /minecraft/data

EXPOSE 25565

CMD java -Xmx1024M -Xms1024M -jar minecraft_server.jar
