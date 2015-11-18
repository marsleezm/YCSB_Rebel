#!/bin/bash

set -e
if [ $# -eq 3 ]
then
	WRatio=$1
	ClusterNodes=$2
	Duration=$3
else
	WRatio=$1
	Duration=$2
        ClusterNodes=`cat scripts/allnodes`
	echo "Nodes not specified.. Using all nodes:""$ClusterNodes"
fi
./scripts/stopNodes.sh "$ClusterNodes"
./scripts/startNodes.sh "$ClusterNodes"
Folder=results/`date +'%Y-%m-%d-%H:%M:%S'`
mkdir $Folder
Output=$Folder/output
ThroughOut=$Folder/throughput

##Load some records and warmup
./scripts/load.sh "$ClusterNodes" 2000000
sleep 300

##Start benchmark
Time=`date +'%Y-%m-%d-%H:%M:%S'`
TimeInSec=`date +%s`
echo "Started at "$Time 

##Limit speed of serving user request
#./scripts/setRequestBand.sh "$ClusterNodes" $1 

##Start workload at the same time
RRatio=$(echo "1-$WRatio" | bc -l)
bin/ycsb run cassandra-cql -p host="$ClusterNodes"  -threads 32 -p updateproportion=$WRatio -p readproportion=$RRatio -p maxexecutiontime=$Duration  -P workloads/cassandraworkload -s > "$Output" 2> "$ThroughOut"

##Output rebalance time and latency
NewTime=`date +'%Y-%m-%d-%H:%M:%S'`
NewTimeInSec=`date +%s`
echo "Finished data transfer at "$NewTime
Diff=$((NewTimeInSec-TimeInSec))

./scripts/dataScript/getLatencyCount.sh $Output latency

