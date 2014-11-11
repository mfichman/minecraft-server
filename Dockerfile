FROM debian

MAINTAINER Matt Fichman <matt.fichman@gmail.com

COPY minecraft/packages.txt /minecraft/packages.txt
COPY minecraft/requirements.txt /minecraft/requirements.txt

RUN apt-get update -y
RUN apt-get install -y `cat /minecraft/packages.txt`
RUN pip install -r /minecraft/requirements.txt

COPY minecraft /minecraft
RUN bash /minecraft/gencert.sh

EXPOSE 443 25565

CMD bash /minecraft/launcher.sh

