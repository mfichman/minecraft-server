#!/bin/bash
set -e

cd /wireguard/WireGuard-0.0.20190702/src

if lsmod | grep wireguard &> /dev/null ; then
  echo "wireguard kernel module is already loaded"
else
  echo "Building wireguard kernel module..."
  make module

  echo "Installing wireguard kernel module..."
  make module-install

  echo "Module installed."
fi

exec $@
