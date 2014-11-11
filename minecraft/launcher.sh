#!/usr/bin/env bash
set -e
cd /minecraft
exec gunicorn launcher:app \
    --bind 0.0.0.0:443 \
    --worker-class gevent \
    --keyfile key.pem \
    --certfile cert.pem
