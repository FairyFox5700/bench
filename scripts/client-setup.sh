#!/bin/bash

cd /home/ubuntu
sudo apt update
sudo apt-add-repository universe
sudo apt update
sudo apt install python2-minimal
python2 -V
whereis python2
sudo ln -s /usr/bin/python2 /usr/bin/python
#install cqlsh
sudo snap install cqlsh
#install java
sudo apt updatepip 
sudo apt install default-jdk -y
#ycsb
curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
tar xfvz ycsb-0.17.0.tar.gz