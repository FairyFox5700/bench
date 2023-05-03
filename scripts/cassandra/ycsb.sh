#!/bin/bash
host_addr="3.248.204.228,3.253.58.60,52.212.34.114"
read_consistency=ONE
write_consistency=QUORUM
workload_name=workloade
thread_count=1
cluster_size=3
database="cassandra"
operationcount=4000
recordcount=2000
resultdir="/home/ubuntu/results"
THREADS="1 2 4 8 16 32 64 128"
OPERATIONS_COUNT="1000 2000 3000 4000 5000 6000"
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
    echo "Running ycsb load for $database with Operation Count: $operationcount and Thread Count as $hread_count"
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
    echo "Running ycsb run for $database with Operation Count: $operationcount and Thread Count as $hread_count"
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
