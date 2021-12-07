#!/usr/bin/env bash

if test -f data/modder.jar; then
  sh run-forge.sh
else
  sh run-vanilla.sh
fi


