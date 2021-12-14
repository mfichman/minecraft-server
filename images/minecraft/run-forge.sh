#!/usr/bin/env bash

if ! test -f install.log; then
  echo 'Running installer'
  java -jar modder.jar --installServer | tee install.log
fi

./run.sh nogui
