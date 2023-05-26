#!/bin/bash
CLUSTER_SIZE=3
PUBLIC_DNS_NAMES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].PublicDnsName" --output text| tr ' ' ',' ))
ips=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*"scylla"*" --query "Reservations[].Instances[].[Tags[?Key=='Name'].Value|[0], PrivateIpAddress]" --output text | sort -k1 | awk '{print $2}')

for ((i=0; i<=CLUSTER_SIZE; i++)); do
  echo "Running nodetool flush -- ycsb metrics on instance $i"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'nodetool flush -- ycsb usertable'
  echo "nodetool status ycsb on $i"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'nodetool status ycsb'
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'sudo systemctl stop scylla-server'
  echo "Clear page cache, dentries, and inodes on $i"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'sudo free; sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches; sudo free'
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'sudo systemctl start scylla-server'
done
