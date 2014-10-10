#!/usr/bin/env bash
set -e
cd /home/#{minecraft.user}/server
export S3_ACCESS_KEY=#{s3.accesskey}
export S3_SECRET_KEY=#{s3.secretkey}
export PASSWORD_HASH=#{minecraft.webpwhash}
exec gunicorn minecraft_launcher:app \
    --bind 0.0.0.0:#{minecraft.webport} \
    --worker-class gevent \
    --keyfile key.pem \
    --certfile cert.pem
