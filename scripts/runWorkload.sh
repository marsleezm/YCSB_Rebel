#!/bin/bash
#sudo killall java
#Output="$2/"`date +'%Y-%m-%d-%H:%M:%S'`"-linear"
Time=`date +'%Y-%m-%d-%H:%M:%S'`

HOST="$1"
WRatio=$3
RRatio=$(echo "1-$WRatio" | bc -l)
Target=$4
Duration=$5
TimeInS=`date +%s`
Output=$2/output
ThroughOut=$2/$Time
echo "Output to $Output"

if [ $Target -eq 0 ]
then
    OPCount=$(( 3000*Duration ))
    echo "Benchmarking nodes:" "$HOST" ReadRatio="$RRatio" WriteRatio="$WRatio" OpCount="$OPCount"  
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 96 -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount  -p maxexecutiontime=$Duration  -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
else
    OPCount=$(( Target*Duration ))
    echo "Benchmarking nodes:" "$HOST" "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio" OpCount="$OPCount
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 96 -p target=$Target -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -p maxexecutiontime=$Duration -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
fi

NewTime=`date +%s`
Duration=$((NewTime-TimeInS))
echo "Benchmark duration: "$Duration
