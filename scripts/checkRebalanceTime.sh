#!/bin/bash
ClusterNodes=$4
AddingNodes=$5
Output=$6
FirstNode=($ClusterNodes)
FirstNode=${FirstNode[0]}

##Load 100000 records...
./scripts/load.sh "$ClusterNodes" 100000 

##Set rebalance speed limit, start adding node
./scripts/command_to_all.sh "$ClusterNodes" "nodetool setstreamthroughput $1" 
echo "Rebalance speed limit: "$1
./scripts/addNode.sh "$AddingNodes"
./scripts/rebalance/rebalance_started.sh $FirstNode 

##Start benchmark
Time=`date +'%Y-%m-%d-%H:%M:%S'`
TimeInSec=`date +%s`
echo "Started at "$Time 

##Limit speed of serving user request
./scripts/setRequestBand.sh "$ClusterNodes" "$ChangeBandWidth"

##Start workload at the same time
./scripts/runWorkload.sh "$ClusterNodes" $Output $2 $3 $7 $8 &
./scripts/rebalance/rebalance_finished.sh $FirstNode

##Output rebalance time and latency
NewTime=`date +'%Y-%m-%d-%H:%M:%S'`
NewTimeInSec=`date +%s`
echo "Finished data transfer at "$NewTime
Diff=$((NewTimeInSec-TimeInSec))

echo $1", "$Diff >> $Output"/rebalance_time"
echo $1", "$2", "$3 >> $Output"/config"

for job in `jobs -p`
        do
                wait $job
        done
echo "Benchmark finished"
./scripts/dataScript/getLatencyCount.sh $Output latency

