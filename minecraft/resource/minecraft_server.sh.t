#!/bin/bash
set -e
cd /home/#{minecraft.user}/server
export S3_ACCESS_KEY=#{s3.accesskey}
export S3_SECRET_KEY=#{s3.secretkey}
python minecraft_s3.py download #{minecraft.savename}
exec python minecraft_launcher.py
