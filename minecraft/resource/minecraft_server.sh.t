#!/usr/bin/env bash
set -e
cd /home/#{minecraft.user}/server
export S3_ACCESS_KEY=#{s3.accesskey}
export S3_SECRET_KEY=#{s3.secretkey}
exec gunicorn minecraft_launcher:app -b 0.0.0.0:#{minecraft.webport} -k gevent
