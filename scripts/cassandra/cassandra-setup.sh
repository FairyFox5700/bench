#!/bin/bash

CLUSTER_SIZE=3
CLUSTER_NAME="cassandra"
# AWS CLI commands to retrieve the IP addresses of the instances in the cluster
INSTANCE_PUBLIC_IP_ADDRESSES_STRING=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].PublicIpAddress" --output text | sed 's/\t/,/g'  )
INSTANCE_PRIVATE_IP_ADDRESSES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].[Tags[?Key=='Name'].Value|[0], PrivateIpAddress]" --output text | sort -k1 | awk '{print $2}' | grep -v None))
INSTANCE_PUBLIC_IP_ADDRESSES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].[Tags[?Key=='Name'].Value|[0], PublicIpAddress]" --output text | sort -k1 | awk '{print $2}' | grep -v None ))

sleep 10
for ((i=0; i<$CLUSTER_SIZE; i++)); do
  echo "Restarting cassandra on instance $i"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo service cassandra stop;"
done

# Loop through the instances and configure Cassndra
for ((i=0; i<$CLUSTER_SIZE; i++)); do
  echo "Configuring host on instance $i"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]} "sudo systemctl stop cassandra;"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]} "sudo rm -rf /var/lib/cassandra/data/*;"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i -- '/seeds/s/127.0.0.1/$INSTANCE_PUBLIC_IP_ADDRESSES_STRING/g' /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i 's/^rpc_address:.*$/rpc_address: 0.0.0.0/g' /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i 's/^num_tokens:.*$/num_tokens: 256/g' /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i 's/^cluster_name:.*$/cluster_name: CassandraBench/g' /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]} "sudo sed -i 's/^endpoint_snitch: .*$/endpoint_snitch: EC2MultiRegionSnitch/g' /etc/cassandra/cassandra.yaml;"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i '/^# broadcast_rpc_address/s/^# *//'  /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i 's/^broadcast_rpc_address:.*$/broadcast_rpc_address: ${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}/g' /etc/cassandra/cassandra.yaml"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo sed -i 's/^listen_address:.*$/listen_address: ${INSTANCE_PRIVATE_IP_ADDRESSES[$i]}/g' /etc/cassandra/cassandra.yaml"
done

for ((i=0; i<$CLUSTER_SIZE; i++)); do
  echo "Restarting cassandra on instance $i"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo systemctl start cassandra;"
done

sleep 60
for ((i=0; i<$CLUSTER_SIZE; i++)); do
  echo "Configuring host on instance $i"
  ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]}  "sudo systemctl status cassandra;"
done

for ((i=0; i<$CLUSTER_SIZE; i++)); do
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
ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]} "cqlsh -e \"$CQL\" "

# Check the status of the YCSB keyspace on the first instance
ssh -o StrictHostKeyChecking=no -i scalla-key.pem ubuntu@${INSTANCE_PUBLIC_IP_ADDRESSES[$i]} "nodetool status ycsb"
done
echo "<<Script finished in $SECONDS seconds>>"