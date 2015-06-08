FROM debian

MAINTAINER Matt Fichman <matt.fichman@gmail.com>

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"\
  | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"\
  | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true\
 | /usr/bin/debconf-set-selections

COPY minecraft/packages.txt /minecraft/packages.txt
RUN apt-get update -y && apt-get install -y `cat /minecraft/packages.txt`
RUN update-alternatives --display java 

COPY minecraft/requirements.txt /minecraft/requirements.txt
RUN pip install -r /minecraft/requirements.txt

COPY minecraft /minecraft
RUN bash /minecraft/gencert.sh
RUN curl -sL https://s3.amazonaws.com/Minecraft.Download/versions/1.8/minecraft_server.1.8.jar > /minecraft/minecraft_server.jar

VOLUME /data

EXPOSE 443 25565
CMD bash /minecraft/launcher.sh

