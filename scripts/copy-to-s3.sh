#!/bin/bash
sudo apt update
sudo apt-get install awscli -y
# Set default region
aws configure set region "eu-west-1" --profile default

aws s3 cp /home/ubuntu/results s3://bench-execution-results-pipeline-bucket/ --recursive