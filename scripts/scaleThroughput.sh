#!/bin/bash

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This experiment adds five nodes into a running cluser of five 
# nodes with different strategy. Due to current load of the cluster,
# the optimal number of nodes to add in each time can be very 
# different. This experiment checkes the rebalance time of adding 
# different number of nodes, namely, from adding node one by
# one to adding all five nodes together.
#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

./scripts/cleanAllNodes.sh

InitialNodes=`head -5 scripts/allnodes`
ExtraNodes=`tail -5 scripts/allnodes`
CurrentNodes=($InitialNodes)
NodesToAdd=($ExtraNodes)
FirstNode=${CurrentNodes[0]} 
AllNodes=$InitialNodes" "$ExtraNodes
NodeNumLeft=${#NodesToAdd[@]}

RebalanceC=20
PreferNum=1

Time=`date +'%Y-%m-%d-%H:%M:%S'`
Folder="results/"$Time"-scale"
mkdir $Folder
#PreferNum
for NodeNumToAdd in $PreferNum $NodeNumLeft; do
	CurrentNodes=($InitialNodes)
	StrCurrentNodes=`echo ${CurrentNodes[@]}`
	NodesToAdd=($ExtraNodes)
	NodeNumLeft=${#NodesToAdd[@]}
	TotalTime=0
    	EstimateDuration=$((160* NodeNumToAdd))
	echo "Add node num:"$NodeNumToAdd
	./scripts/stopNodes.sh "$AllNodes"
	./scripts/startNodes.sh "$InitialNodes"
	./scripts/load.sh "$StrCurrentNodes" 800000
while [ "$NodeNumLeft" -ne 0 ]
do
	StrCurrentNodes=`echo ${CurrentNodes[@]}`
	#./scripts/runWorkload.sh "$StrCurrentNodes" $Folder "0.5" 0 $EstimateDuration &
    	#Sleep 60s to run benchmark and check stable performance.
    	#sleep 60
	echo "Remainging nodes:"${NodesToAdd[@]}
	NodeNumToAdd=$((NodeNumToAdd>NodeNumLeft?NodeNumLeft:NodeNumToAdd))
	echo "Num of nodes to add:"$NodeNumToAdd

	AddingNodes="${NodesToAdd[@]:0:$NodeNumToAdd}"  #$NodesRound}")

	./scripts/command_to_all.sh "$StrCurrentNodes" "nodetool setstreamthroughput $RebalanceC"
	./scripts/addNode.sh "$AddingNodes"
	
	./scripts/rebalance/rebalance_started.sh $FirstNode	
	StartTime=`date +%s`
	./scripts/rebalance/rebalance_finished.sh $FirstNode
	FinishTime=`date +%s`

	TotalTime=$((TotalTime + FinishTime - StartTime))
	NodeNumLeft=$((NodeNumLeft-NodeNumToAdd))
	NodesToAdd=("${NodesToAdd[@]:$NodeNumToAdd:$NodeNumLeft}")
	AddingNodes=($AddingNodes)
	CurrentNodes=("${CurrentNodes[@]}"  "${AddingNodes[@]}")
	echo "Current nodes:"${CurrentNodes[@]}
	
	echo "Total time:"$TotalTime 
	echo $NodeNumToAdd $StartTime $FinishTime $TotalTime >> $Folder/"duration"
	echo "Rebalance finished"
done
	echo "Total time:"$TotalTime 
	echo $TotalTime >> $Folder/"duration"
	for job in `jobs -p`
	do
    		wait $job
	done
	echo "Benchmark finished"
done
echo "Finalizing.."
./scripts/stopNodes.sh "$AllNodes"

