#!/bin/bash
Base=3000
MAXTarget=7000
UpIntervalNum=5
UpDelta=$(((MAXTarget-Base) / UpIntervalNum))
HOST='10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118'
for I in $(eval echo "{1..$UpIntervalNum}")
do
    Output="$1/"`date +'%Y-%m-%d-%H:%M:%S'`"-increase"
    Target=$((UpDelta * I + Base))
    echo "*****Target is $Target*****"
    #echo "Output to $Output"  
    OpCount=$((Target* 19))
    Result=`ssh ubuntu@10.20.0.16 -X -i ~/Elasticity.pem "sudo service cassandra status"`
    if [[ $Result == *"Cassandra is running"* ]]	
	then
	HOST='10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118 10.20.0.16 10.20.0.18'
    fi
    echo $HOST
    bin/ycsb run cassandra-cql -p host="$HOST" -threads 40 -target $Target -p operationcount=$OpCount -s -P workloads/cassandraworkload > $Output
done


DownIntervalNum=3
DownDelta=$(((MAXTarget - Base) / DownIntervalNum))
Count=1
for I in $(eval echo "{$((DownIntervalNum - 1))..1}")
do
    Output="$1/"`date +'%Y-%m-%d-%H:%M:%S'`"-reduce"
    Target=$((DownDelta * I + Base))
    OpCount=$((Target * 19))
    echo "*****Target is $Target*****"
    #echo "Output to $Output"  
    Result=`ssh ubuntu@10.20.0.16 -X -i ~/Elasticity.pem "sudo service cassandra status"`
    if [[ $Result == *"Cassandra is running"* ]]
	then
	HOST='10.20.0.51 10.20.0.81 10.20.0.117 10.20.0.118 10.20.0.16 10.20.0.18'
    fi
    echo $HOST
    bin/ycsb run cassandra-cql -p host="$HOST" -threads 40 -target $Target -p operationcount=$OpCount -s -P workloads/cassandraworkload > $Output
    Count=$((Count+1))
done
