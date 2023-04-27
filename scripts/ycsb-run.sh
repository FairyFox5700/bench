THREADS="1 2 4 8 16 32 64 128 256 512"
TARGETS="500 1000 2000 4000 8000 16000 32000 64000 128000"
$phaseType 
US="_"
$YCSB_HOME
cd ycsb-0.17.0
$worload="workloada"
for target in ${TARGETS[@]}
do    
    for thread in ${THREADS[@]}
    do
	date
	echo "Doing the run for Scylla Target as $target and Thread as $thread"
       .bin/ycsb run cassandra-cql -s -P workloads/workloada -p hosts=176.34.73.10 
       $YCSB_HOME/bin/ycsb $phaseType $db  -P $YCSB_HOME/workloads/$worload -p recordcount=$oc -p operationcount=$oc | tee $OUTPUT_DIR/${db}_${wl}_${oc}_${phaseType}_${TEST_DATE}.txt
       ./bin/ycsb run cassandra-10 -P workloads/workloada -P large.dat -p hosts=compg0,compg1,compg2 -p operationcount=300000 -target ${target} -threads ${thread} -s &> cassandrarun${target}${US}${thread}.out
	echo "Run for Scylla Target as $target and Thread as $thread done"
	date
	sleep 5
    done    	
done

echo "Script completed"