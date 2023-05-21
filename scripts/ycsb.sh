#!/bin/bash

# default parameter values
host_addr="34.242.206.20,34.248.123.137,52.48.128.110"
read_consistency="ONE"
write_consistency="QUORUM"
workload_name="workloada"
THREADS="1 2"
cluster_size=3
database="scylla"
OPERATIONS_COUNT="2000 4000"
recordcount=1000
resultdir="/home/ubuntu/results"

# parse command-line arguments
while getopts ":a:r:w:n:t:s:d:o:c:u:" opt; do
  case $opt in
    a) host_addr=$OPTARG;;
    r) read_consistency=$OPTARG;;
    w) write_consistency=$OPTARG;;
    n) workload_name=$OPTARG;;
    t) THREADS=$OPTARG;;
    s) cluster_size=$OPTARG;;
    d) database=$OPTARG;;
    o) OPERATIONS_COUNT=$OPTARG;;
    c) recordcount=$OPTARG;;
    u) resultdir=$OPTARG;;
    \?) echo "Invalid option: -$OPTARG" >&2;;
  esac
done

# Print the arguments passed
echo "Arguments passed:"
echo "host_addr: $host_addr"
echo "read_consistency: $read_consistency"
echo "write_consistency: $write_consistency"
echo "workload_name: $workload_name"
echo "thread_count: $THREADS"
echo "cluster_size: $cluster_size"
echo "database: $database"
echo "operationcount: $OPERATIONS_COUNT"
echo "recordcount: $recordcount"
echo "resultdir: $resultdir"

#mkdir for results
sudo mkdir results
sudo chmod a+rwx results

cd ycsb-0.17.0

for thread_count in ${THREADS[@]}
do    
    for operationcount in ${OPERATIONS_COUNT[@]}
    do
	date

	#phase load
    echo "Running ycsb load for $database with Operation Count: $operationcount and Thread Count as $thread_count"
	sudo ./bin/ycsb load cassandra-cql \
	-P workloads/$workload_name \
	-threads $thread_count \
	-p recordcount=$recordcount \
	-p operationcount=$operationcount \
	-p cassandra.readconsistencylevel=$read_consistency \
	-p cassandra.writeconsistencylevel=$write_consistency \
	-p hosts=$host_addr -s > $resultdir/database=${database}_threads=${thread_count}_workload=${workload_name}_operations=${operationcount}_records=${recordcount}_phase=load.csv
    echo "Finished execution of ycsb load for $database with Operation Count: $operationcount and Thread Count as $hread_count"
	
    #phase run
    echo "Running ycsb run for $database with Operation Count: $operationcount and Thread Count as $thread_count"
	sudo ./bin/ycsb run cassandra-cql \
	-P workloads/$workload_name \
	-threads $thread_count \
	-p recordcount=$recordcount \
	-p operationcount=$operationcount \
	-p cassandra.readconsistencylevel=$read_consistency \
	-p cassandra.writeconsistencylevel=$write_consistency \
	-p hosts=$host_addr -s > $resultdir/database=${database}_threads=${thread_count}_workload=${workload_name}_operations=${operationcount}_records=${recordcount}_phase=run.csv

    echo "Finished execution of ycsb run for $database with Operation Count: $operationcount and Thread Count as $hread_count"
	
	date
	sleep 5
    done    	
done

echo "Script completed"
