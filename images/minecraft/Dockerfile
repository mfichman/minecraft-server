FROM openjdk:15-alpine
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
ARG SERVER_JAR_URL=https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
WORKDIR /minecraft
VOLUME /data

RUN apk add socat
RUN ln -sn /data /minecraft/world

COPY eula.txt ops.txt server.properties /minecraft/
ADD $SERVER_JAR_URL /minecraft/minecraft_server.jar

EXPOSE 25566 25565
CMD socat EXEC:"java -Xmx1024M -Xms1024M -jar minecraft_server.jar",pty TCP-LISTEN:25566,fork
