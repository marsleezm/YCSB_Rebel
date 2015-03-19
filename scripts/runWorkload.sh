#!/bin/bash
#sudo killall java
#Output="$2/"`date +'%Y-%m-%d-%H:%M:%S'`"-linear"
if [ "$#" -eq 6 ]; then
	Bandwidth=$(($6*8000))
	Burst=$(($6*16000))
	command="sudo tc class change dev eth0 parent 1:1 classid 1:10 htb rate ${Bandwidth}kbit burst ${Burst}k prio 1"
	./scripts/command_to_all.sh "$1" "$command" 
fi

Time=`date +'%Y-%m-%d-%H:%M:%S'`
Output=$2/$Time
ThroughOut=$2/$Time"-throughput"
echo "Output to $Output"
HOST="$1"
WRatio=$3
RRatio=$(echo "1-$WRatio" | bc -l)
Duration=$5
Time=`date +%s`
Target=$4
if [ $Target -eq 0 ]
then
    OPCount=$(( 2000*Duration ))
    echo "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
else
    OPCount=$(( Target*Duration ))
    echo "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio
    bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -p target=$Target -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"
fi

NewTime=`date +%s`
Duration=$((NewTime-Time))
echo "Benchmark duration: "$Duration
