FROM debian

MAINTAINER Matt Fichman <matt.fichman@gmail.com

COPY minecraft/packages.txt /minecraft/packages.txt
RUN apt-get update && apt-get install -y `cat /minecraft/packages.txt`

COPY minecraft/requirements.txt /minecraft/requirements.txt
RUN pip install -r /minecraft/requirements.txt

COPY minecraft /minecraft
RUN bash /minecraft/gencert.sh
RUN curl -sL https://s3.amazonaws.com/Minecraft.Download/versions/1.8/minecraft_server.1.8.jar > /minecraft/minecraft_launcher.jar

VOLUME /data
EXPOSE 443 25565
CMD bash /minecraft/launcher.sh

