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


#Stop all Cassandra nodes.
./scripts/cleanAllNodes.sh 

InitialNodes=`head -5 scripts/allnodes`
ExtraNodes=`tail -5 scripts/allnodes`
CurrentNodes=($InitialNodes)
NodesToAdd=($ExtraNodes)
FirstNode=${CurrentNodes[0]} 
AllNodes=$InitialNodes" "$ExtraNodes
NodeNumLeft=${#NodesToAdd[@]}

TotalLoad=$1
NodeC=$2

Time=`date +'%Y-%m-%d-%H:%M:%S'`
for NodeNumToAdd in $(seq 1 $NodeNumLeft); do
	Round=$NodeNumToAdd
	TotalTime=0
	CurrentNodes=($InitialNodes)
	StrCurrentNodes=`echo ${CurrentNodes[@]}`
	NodesToAdd=($ExtraNodes)
	CurrentNodeNum=${#CurrentNodes[@]}
	NodeNumLeft=${#NodesToAdd[@]}
	echo "Add node num:"$NodeNumToAdd
	./scripts/stopNodes.sh "$AllNodes"
	./scripts/startNodes.sh "$InitialNodes"
	./scripts/load.sh "$StrCurrentNodes" 800000
while [ "$NodeNumLeft" -ne 0 ]
do
	StrCurrentNodes=`echo ${CurrentNodes[@]}`
	echo "Nodes to add:"${NodesToAdd[@]}
	RemainC=$((NodeC-TotalLoad/CurrentNodeNum))
	NodeNumToAdd=$((NodeNumToAdd>NodeNumLeft?NodeNumLeft:NodeNumToAdd))
	NodeNumToAdd=$((NodeNumToAdd>1?NodeNumToAdd:1))
	echo "Capacity for rebalance:"$RemainC", Num of nodes to add:"$NodeNumToAdd

	AddingNodes="${NodesToAdd[@]:0:$NodeNumToAdd}"

	./scripts/command_to_all.sh "$StrCurrentNodes" "nodetool setstreamthroughput $RemainC"
	./scripts/addNode.sh "$AddingNodes"
	./scripts/rebalance/rebalance_started.sh $FirstNode

	UsedTime=`./scripts/rebalance/rebalance_finish_time.sh $FirstNode`
	TotalTime=$(echo $TotalTime+$UsedTime | bc -l ) 	
	echo "Used: "$UsedTime

	CurrentNodeNum=$((CurrentNodeNum+NodeNumToAdd))
	echo "CurrentNode: "$CurrentNodeNum

	AddingNodes=($AddingNodes)
	NodeNumLeft=$((NodeNumLeft-NodeNumToAdd))
	NodesToAdd=("${NodesToAdd[@]:$NodeNumToAdd:$NodeNumLeft}")
	CurrentNodes=("${CurrentNodes[@]}"  "${AddingNodes[@]}")
	echo "Current nodes:"${CurrentNodes[@]}
	
	echo " "
done
	echo $Round", "$TotalTime >> results/rebalance_graph$Time
done

echo "Load:"$TotalLoad", Node capacity:"$NodeC >> results/rebalance_graph$Time
echo "Finalizing..." 
./scripts/stopNodes.sh "$AllNodes"
