#!/bin/bash
echo "Loading to $1"
TimeInSec=`date +%s`
Count=$2
bin/ycsb load cassandra-cql -p host="$1" -p recordcount=$Count -threads 8 -P workloads/cassandraworkload -s 
FinishTimeInSec=`date +%s`
Duration=$((FinishTimeInSec-TimeInSec))

	
#bin/ycsb load cassandra-cql -p host="10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118"  -threads 40 -P workloads/cassandraworkload -s 
