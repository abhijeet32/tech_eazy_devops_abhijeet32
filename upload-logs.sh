#!/bin/bash
apt-get update -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
mkdir -p /app/logs && echo "App log" > /app/logs/app.log
BUCKET="${aws_s3_bucket.logs_bucket.id}"
aws s3 cp /var/log/cloud-init.log s3://$BUCKET/logs/system/
aws s3 cp /app/logs s3://$BUCKET/logs/app/ --recursive