#!/bin/bash
sudo apt-get update
sudo apt install default-jdk -y
sudo apt install wget
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
echo "deb https://debian.cassandra.apache.org 40x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
sudo apt-get update
sudo apt-get install cassandra -y
sudo systemctl enable cassandra
sudo systemctl start cassandra