#!/usr/bin/env bash

if ! test -f data/minecraft_server.jar; then
  echo 'Server is up! Please load a world'
  sleep infinity
elif test -f data/modder.jar; then
  sh run-forge.sh
else
  sh run-vanilla.sh
fi


