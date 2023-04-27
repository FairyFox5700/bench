#!/bin/bash

exec &> /tmp/mylog.txt

CLUSTER_SIZE=3
CLUSTER_NAME="scylla"
# AWS CLI commands to retrieve the IP addresses of the instances in the cluster
INSTANCE_PUBLIC_IP_ADDRESSES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[*].PublicIpAddress" --output text | tr ' ' ',' ))
INSTANCE_PRIVATE_IP_ADDRESSES=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].[PrivateIpAddress, Tags[?Key==`Name`].Value[0]" --output text | sort -k 2 | tr ' ' ',' )
INSTANCE_PRIVATE_IP_ADDRESSES_ARRAY=($INSTANCE_PRIVATE_IP_ADDRESSES)
PUBLIC_DNS_NAMES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].PublicDnsName" --output text| tr ' ' ',' ))
# Loop through the instances and configure Scylla
for ((i=0; i<$CLUSTER_SIZE; i++)); do
  echo "Configuring host on instance $i"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]}  "sudo sed -i -- '/seeds/s/127.0.0.1/$INSTANCE_PUBLIC_IP_ADDRESSES/g' /etc/scylla/scylla.yaml"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]}  "sudo sed -i 's/^rpc_address:.*$/rpc_address: 0.0.0.0/g' /etc/scylla/scylla.yaml"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]}  "sudo sed -i 's/^broadcast_rpc_address:.*$/broadcast_rpc_address: $INSTANCE_PUBLIC_IP_ADDRESSES/g' /etc/scylla/scylla.yaml"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]}  "sudo sed -i 's/^listen_address:.*$/listen_address: ${INSTANCE_PRIVATE_IP_ADDRESSES_ARRAY[$i]}/g' /etc/scylla/scylla.yaml"
  ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]}  "sudo systemctl restart scylla-server; sleep 2; sudo systemctl status scylla-server"
done

# Wait for Scylla to start up
sleep 10

# Create the keyspace and table for the YCSB Timeseries Workload
CQL="DROP KEYSPACE IF EXISTS ycsb; CREATE KEYSPACE IF NOT EXISTS ycsb WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': '${CLUSTER_SIZE}'} AND DURABLE_WRITES = true; USE ycsb; DROP TABLE IF EXISTS usertable; CREATE TABLE usertable (
    y_id varchar primary key,
    field0 varchar,
    field1 varchar,
    field2 varchar,
    field3 varchar,
    field4 varchar,
    field5 varchar,
    field6 varchar,
    field7 varchar,
    field8 varchar,
    field9 varchar);"
echo "Creating keyspace and table for YCSB Timeseries Workload..."
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[0]} "until echo \"$CQL\" | cqlsh ; do echo \"Scylla not yet up and running, will try again in 2 seconds...\"; sleep 2; done"

# Check the status of the YCSB keyspace on the first instance
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[0]} "nodetool status ycsb"

echo "<<Script finished in $SECONDS seconds>>"