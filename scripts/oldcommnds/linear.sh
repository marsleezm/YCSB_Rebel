#!/bin/bash
#sudo killall java
Output="$1/"`date +'%Y-%m-%d-%H:%M:%S'`"-linear"
echo "Output to $Output"
#HOST='10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118'
HOST='10.20.0.117'
#Result=`ssh ubuntu@10.20.0.16 -X -i ~/Elasticity.pem "sudo service cassandra status"`
#if [[ $Result == *"Cassandra is running"* ]]
#        then
#        HOST='10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118 10.20.0.16 10.20.0.18'
#fi
#bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -target 3000 -p operationcount=200000 -P workloads/cassandraworkload -s > $Output
bin/ycsb run cassandra-cql -p host=$HOST  -threads 30 -p operationcount=150000 -P workloads/cassandraworkload -s > testOutput 
