#!/bin/bash

host_addr="63.32.62.107"
read_consistency=ONE
write_consistency=QUORUM
workload_name=workloada
thread_count=1
cluster_size=3
dir="cluster"
database="scylla"
operationcount=400
recordcount=1000
resultdir="/home/ubuntu/results"

#mkdir for results
sudo mkdir results
sudo chmod a+rwx results

cd /ycsb-0.17.0

#phase load
read_consistency=ALL
write_consistency=ALL

filename=database=${database}_threads=${thread_count}_workload=${workload_name}_operations=${operationcount}_records=${recordcount}_phase=${phase}.csv
sudo ./bin/ycsb $phase cassandra-cql \
-P workloads/$workload_name \
-threads $thread_count \
-p recordcount=$recordcount \
-p operationcount=$operationcount \
-p cassandra.readconsistencylevel=$read_consistency \
-p cassandra.writeconsistencylevel=$write_consistency \
-p hosts=$host_addr -s > $resultdir/$filename

#phase run
phase="run"

sudo ./bin/ycsb $phase cassandra-cql \
-P workloads/$workload_name \
-threads $thread_count \
-p recordcount=$recordcount \
-p operationcount=$operationcount \
-p cassandra.readconsistencylevel=$read_consistency \
-p cassandra.writeconsistencylevel=$write_consistency \
-p hosts=$host_addr -s > $resultdir/$filename
