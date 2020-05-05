FROM openjdk:15-alpine
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
WORKDIR /minecraft

ARG SERVER_JAR_URL=https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
#ARG FORGE_JAR_URL=https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.15.2-31.1.74/forge-1.15.2-31.1.74-installer.jar

ADD $SERVER_JAR_URL /minecraft/minecraft_server.jar
#ADD $FORGE_JAR_URL /minecraft/minecraft_forge_installer.jar

COPY . /minecraft

#RUN java -jar minecraft_forge_installer.jar --installServer

VOLUME /minecraft/data

EXPOSE 25565

CMD java -Xmx1024M -Xms1024M -jar minecraft_server.jar
