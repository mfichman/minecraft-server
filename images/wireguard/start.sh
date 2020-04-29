#!/bin/bash

set -e

function cleanup() {
  wg-quick down $INTERFACE
  echo "Wireguard stopped"
  exit 0
}

trap cleanup SIGTERM
trap cleanup EXIT

wg-quick up $INTERFACE
echo "Wireguard started"

set +e
