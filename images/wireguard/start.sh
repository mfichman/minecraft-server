#!/bin/bash

set -e

cd WireGuard-0.0.20190702/src

if lsmod | grep wireguard &> /dev/null ; then
  echo "wireguard kernel module is already loaded"
else
  echo "Building wireguard kernel module..."
  make module

  echo "Installing wireguard kernel module..."
  make module-install

  echo "Module installed."
fi

function cleanup() {
  wg-quick down $INTERFACE
  echo "Wireguard stopped"
  exit 0
}

trap cleanup SIGTERM
trap cleanup EXIT

touch /etc/wireguard/wg0.conf

wg-quick up $INTERFACE
echo "Wireguard started"

set +e
