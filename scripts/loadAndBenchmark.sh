#!/bin/bash
ClusterNodes=$4
AddingNodes=$5
Output=$6
FirstNode=($ClusterNodes)
FirstNode=${FirstNode[0]}

##Load some records and warmup
./scripts/load.sh "$ClusterNodes" 200000
sleep 300
./scripts/warmup.sh "$ClusterNodes" 0.1 100000
sleep 60

##Start benchmark
Time=`date +'%Y-%m-%d-%H:%M:%S'`
TimeInSec=`date +%s`
echo "Started at "$Time 

##Limit speed of serving user request
#./scripts/setRequestBand.sh "$ClusterNodes" $1 

##Start workload at the same time
./scripts/runWorkload.sh "$ClusterNodes" $Output $2 $3 $7

##Output rebalance time and latency
NewTime=`date +'%Y-%m-%d-%H:%M:%S'`
NewTimeInSec=`date +%s`
echo "Finished data transfer at "$NewTime
Diff=$((NewTimeInSec-TimeInSec))

./scripts/dataScript/getLatencyCount.sh $Output latency

