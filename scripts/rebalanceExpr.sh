#!/bin/bash

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This experiment measures the impact of data rebalance bandwidth,
# the write ratio and number of system throughput on operation latency.
# We add a node to an running node and limit the bandwidth for serving
# workload (with tc by configRequestBand.sh) and data rebalance workload
# , change the number of requesting throughput and write ratio to check
# how the latency changes.  
#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
./scripts/cleanAllNodes.sh

ExistingNodes=`head -1 scripts/allnodes`
NodesToAdd=`tail -3 scripts/allnodes`
FirstNode=`head -1 scripts/allnodes`
echo "Existing nodes are " "$ExistingNodes" ", nodes to add are " "$NodesToAdd"
AllNodes=$ExistingNodes" "$NodesToAdd

for i in `seq 1 3`;
do
	Time=`date +'%Y%m%d-%H%M%S'`
	Folder="results/$Time-rebel-expr"
	mkdir $Folder
	./scripts/stopNodes.sh "$AllNodes"
	./scripts/startNodes.sh "$ExistingNodes"
	echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."

	./scripts/load.sh "$ExistingNodes" 100000
	sleep 200
	./scripts/fetchRingInfo.sh $Folder  start
	./scripts/fetchNetworkUsg.sh $Folder  start

	./scripts/addNode.sh "$NodesToAdd"
	./scripts/rebalance/rebalance_started.sh $FirstNode

	Time=`date +'%Y-%m-%d-%H:%M:%S'`
	TimeInSec=`date +%s`
	echo "Started at "$Time
	./scripts/rebalance/rebalance_finished.sh $FirstNode

	##Output rebalance time and latency
	NewTime=`date +'%Y-%m-%d-%H:%M:%S'`
	NewTimeInSec=`date +%s`
	echo "Finished data transfer at "$NewTime
	Diff=$((NewTimeInSec-TimeInSec))
	echo $Diff >> $Folder"/rebalance_time"

	./scripts/fetchRingInfo.sh $Folder end 
	./scripts/fetchNetworkUsg.sh $Folder end 
	./scripts/compareRebelStatDiff.sh $Folder

done
