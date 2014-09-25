#!/usr/bin/env bash -e
cd /home/#{minecraft.user}/server
export S3_ACCESS_KEY=#{s3.accesskey}
export S3_SECRET_KEY=#{s3.secretkey}
exec python minecraft_launcher.py --port=#{minecraft.webport}
