#!/bin/bash
ClusterNodes=$4
AddingNodes=$5
Output=$6
FirstNode=($ClusterNodes)
FirstNode=${FirstNode[0]}
./scripts/load.sh "$ClusterNodes" 100000 

#Get overall latency
#QueryResult=$(./scripts/command_to_all.sh "nodetool cfstats ycsb" 1)
#tmp=$(echo "$QueryResult"|awk 'NR==4')
#IFS=':' read -ra ARR <<< "$tmp"
#Count=${ARR[1]}
#Count=`echo $Count | tr -d '\r'`
#tmp=`echo "$QueryResult"| awk 'NR==5'`
#IFS=':' read -ra ARR <<< "$tmp"
#tmp=${ARR[1]}
#tmp=${tmp#?}
#Latency=${tmp%?????}
#OverallUpdate=$(echo "($Count * $Latency)" | bc -l)
#echo $Latency" "$Count" "$OverallUpdate
#exit

./scripts/command_to_all.sh "$ClusterNodes" "nodetool setstreamthroughput $1" 
echo "Rebalance speed limit: "$1
./scripts/addNode.sh "$AddingNodes"

./scripts/rebalance/rebalance_started.sh $FirstNode 

##Start benchmark
Time=`date +'%Y-%m-%d-%H:%M:%S'`
TimeInSec=`date +%s`
echo "Started at "$Time 

echo "Request speed limit: "$8
./scripts/runWorkload.sh $ClusterNodes $Output $2 $3 $7 $8 &
##Check that benchmark is running
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

