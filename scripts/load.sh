#!/bin/bash

TimeInSec=`date +%s`
if [ $# -eq 2 ]; then
    echo "$1" > ./to_load
    Count=$2
else
    Count=$1
fi

echo "Loading to" "`cat ./to_load`"
echo marco | sudo -S cassandra-stress user profile=./rebel.yaml ops\(insert=1\) n=$Count -node file=./to_load -rate threads=48
#bin/ycsb load cassandra-cql -p host="$1" -p recordcount=$Count -threads 10  -p target=3000 -P workloads/cassandraworkload -s 
FinishTimeInSec=`date +%s`
Duration=$((FinishTimeInSec-TimeInSec))

#bin/ycsb load cassandra-cql -p host="10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118"  -threads 40 -P workloads/cassandraworkload -s 
