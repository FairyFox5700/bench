#!/bin/bash
    sudo apt update
    sudo apt-get install awscli
    aws s3 cp /home/ubuntu/results s3://bench-execution-results-pipeline/ --recursive