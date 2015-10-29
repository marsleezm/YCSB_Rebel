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

ExistingNodes=`head -2 scripts/allnodes`
NodesToAdd=`tail -2 scripts/allnodes`
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

	./scripts/load.sh "$ExistingNodes" 150000
	./scripts/checkPortStat.sh "$NodesToAdd" 150 $Folder &
	sleep 60
	./scripts/fetchNetworkUsg.sh $Folder  start

	./scripts/addNode.sh "$NodesToAdd"
	./scripts/command_to_all.sh "$NodesToAdd" "sudo iptables -A OUTPUT -p tcp --dport 9042"
	./scripts/rebalance/rebalance_started.sh $FirstNode

	Time=`date +'%Y-%m-%d-%H:%M:%S'`
	TimeInSec=`date +%s`
	echo "Started at "$Time
	./scripts/runWorkload.sh "$AllNodes" $Folder 0.1 0 80 &
	./scripts/rebalance/rebalance_finished.sh $FirstNode

	##Output rebalance time and latency
	NewTime=`date +'%Y-%m-%d-%H:%M:%S'`
	NewTimeInSec=`date +%s`
	echo "Finished data transfer at "$NewTime
	Diff=$((NewTimeInSec-TimeInSec))
	echo "Finished at":$NewTimeInSec", used"$Diff >> $Folder"/rebalance_time"

	for job in `jobs -p`
        do
                wait $job
        done
	./scripts/command_to_all.sh "nodetool cleanup"
	./scripts/fetchNetworkUsg.sh $Folder end 
done
