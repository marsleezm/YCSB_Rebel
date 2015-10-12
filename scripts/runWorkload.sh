#!/bin/bash
#sudo killall java
#Output="$2/"`date +'%Y-%m-%d-%H:%M:%S'`"-linear"
Time=`date +'%Y-%m-%d-%H:%M:%S'`
Output=$2/$Time
ThroughOut=$2/$Time"-throughput"
echo "Output to $Output"

HOST="$1"
WRatio=$3
RRatio=$(echo "1-$WRatio" | bc -l)
Target=$4
Duration=$5
Time=`date +%s`

if [ $Target -eq 0 ]
then
    OPCount=$(( 2000*Duration ))
    echo "Benchmarking nodes:" "$HOST" "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio" OpCount"=$OPCount
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
else
    OPCount=$(( Target*Duration ))
    echo "Benchmarking nodes:" "$HOST" "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio" OpCount="$OPCount
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -p target=$Target -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
fi

NewTime=`date +%s`
Duration=$((NewTime-Time))
echo "Benchmark duration: "$Duration
