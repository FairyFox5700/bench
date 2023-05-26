#!/bin/bash
CLUSTER_SIZE=3

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

PUBLIC_DNS_NAMES=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$CLUSTER_NAME*" --query "Reservations[].Instances[].PublicDnsName" --output text))

for ((i=0; i<=CLUSTER_SIZE; i++)); do 
echo "Checking space used on instance $i - ${PUBLIC_DNS_NAMES[$i]}"; 
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "nodetool cfstats ycsb.usertable";

echo "Dropping and re-creating keyspace and table for YCSB Timeseries Workload..."
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "cqlsh -e \"$CQL\" "
echo "Getting Info about ycsb keyspace via cqlsh..."
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "cqlsh -e "DESC keyspace ycsb";"

echo "Running nodetool cleanup on instance $i";
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'nodetool cleanup';
echo "Running nodetool clearsnapshot on instance $i";
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} 'nodetool clearsnapshot';
echo "Checking space used on instance $i"; 
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "nodetool cfstats ycsb.usertable";
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "sudo systemctl stop scylla-server;"
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "sudo rm -rf /var/lib/scylla/data/*;"
ssh -i scalla-key.pem scyllaadm@${PUBLIC_DNS_NAMES[$i]} "sudo systemctl start scylla-server;"
done
