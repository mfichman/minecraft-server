#!/usr/bin/env bash

# Directory layout:
# /minecraft/data
# /minecraft/data/cache/jars/...
# /minecraft/data/cache/modders/...
# /minecraft/data/cache/mods/...
# /minecraft/data/installs/...
# /minecraft/data/backups/...
# /minecraft/data/run/world
# /minecraft/data/run/minecraft_server.jar
# /minecraft/data/run/modder.jar
# /minecraft/data/run/mods

if ! test -d data/run; then
  echo 'Server is up! Please load a world'
  sleep infinity
elif test -f data/run/modder.jar; then
  cd data/run
  sh /minecraft/run-forge.sh
else
  cd data/run
  sh /minecraft/run-vanilla.sh
fi
