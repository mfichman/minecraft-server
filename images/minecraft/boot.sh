#!/usr/bin/env sh

JAR=/minecraft/jars/server-$MINECRAFT_SERVER_JAR_VERSION.jar

if [ -f "$JAR" ]; then
  curl $MINECRAFT_SERVER_JAR_URL > $JAR
fi

java -Xmx1024M -Xms1024M -jar $JAR nogui
