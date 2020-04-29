#!/bin/bash

set -e

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
