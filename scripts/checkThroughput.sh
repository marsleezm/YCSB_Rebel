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
#./scripts/cleanAllNodes.sh
ExistingNodes=`head -4 scripts/allnodes`
NodesToAdd=`tail -2 scripts/allnodes`
FirstNode=`head -1 scripts/allnodes`
echo "Existing nodes are " "$ExistingNodes" ", nodes to add are " "$NodesToAdd"
AllNodes=$ExistingNodes" "$NodesToAdd

#./scripts/stopAndRemove.sh 172.31.3.161
#./scripts/startNodes.sh 172.31.3.161
#./scripts/rebalance/rebalance_started.sh $FirstNode
#./scripts/rebalance/rebalance_finished.sh $FirstNode


Limits="0 2 5 10"
for Limit in $Limits;
do
	sleep 300
	Time=`date +'%Y%m%d-%H%M%S'`
	Folder="results/$Time-rebel-expr"
	mkdir $Folder
	./scripts/stopNodes.sh "$ExistingNodes" 
	./scripts/startNodes.sh "$ExistingNodes" 
	./scripts/command_to_all.sh "$AllNodes" "nodetool setstreamthroughput 0"
	./scripts/parallelCommand.sh "$NodesToAdd" "nodetool decommission"
	./scripts/stopAndRemove.sh "$NodesToAdd"
	./scripts/parallelCommand.sh "$ExistingNodes" "nodetool repair"
	Target=2300
	WRatio=0.1
	if [ $Limit -eq 0 ];
	then
	    RebalanceTime=$((5000/15))
	    TotalTime=$((RebalanceTime+1200+1200))
	else
	    RebalanceTime=$((5000/Limit))
	    TotalTime=$((RebalanceTime+1200+1200))
	fi
	touch $Folder/$Limit"M"
	echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
	./scripts/command_to_all.sh "$AllNodes" "nodetool setstreamthroughput $Limit"
	./scripts/testRebalanceStatus.sh $Folder &
	./scripts/runWorkload.sh "$AllNodes" $Folder $WRatio $Target $TotalTime &
	sleep 1200

	./scripts/addNode.sh "$NodesToAdd"
	./scripts/rebalance/rebalance_started.sh $FirstNode
	T=`date +'%Y-%m-%d-%H:%M:%S'`
	TInSec=`date +%s`
	echo "Rebalance started" $T >> $Folder/rebel_dur
	echo "Rebalance finished" $T 

	./scripts/rebalance/rebalance_finished.sh $FirstNode
	T2=`date +'%Y-%m-%d-%H:%M:%S'`
	echo "Rebalance finished" $T2 >> $Folder/rebel_dur
	echo "Rebalance finished" $T2 

	##Output rebalance time and latency
	for job in `jobs -p`
        do
                wait $job
        done
done
