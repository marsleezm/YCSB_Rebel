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

set -e
ExistingNodes=`head -4 scripts/allnodes`
NodesToAdd=`tail -2 scripts/allnodes`
FirstNode=`head -1 scripts/allnodes`
echo "Existing nodes are " "$ExistingNodes" ", nodes to add are " "$NodesToAdd"
AllNodes=$ExistingNodes" "$NodesToAdd

#./scripts/rebalance/rebalance_started.sh $FirstNode
#./scripts/rebalance/rebalance_finished.sh $FirstNode

sudo ./scripts/copyToAll.sh ./scripts/getDStat.sh


BeforeRebalance=2000
AfterRebalance=1800
Limits="2000 100000"
for Limit in $Limits;
do
	Time=`date +'%Y%m%d-%H%M%S'`
	Folder="results/$Time-rebel-expr"
	mkdir $Folder
	./scripts/configRequestBand.sh
	./scripts/stopAndRemove.sh "$AllNodes" 
	sudo ./scripts/parallelCommand.sh "sudo iptables -D OUTPUT -p tcp --sport 9042"
	sudo ./scripts/parallelCommand.sh "sudo iptables -D INPUT -p tcp --dport 9042"
	sudo ./scripts/parallelCommand.sh "$ExistingNodes" "sudo iptables -D OUTPUT -p tcp --sport 7000"
	sudo ./scripts/parallelCommand.sh "$NodesToAdd" "sudo iptables -D INPUT -p tcp --sport 7000"
	./scripts/startNodes.sh "$ExistingNodes" 
	./scripts/load.sh "$ExistingNodes" 2000000
	#./scripts/load.sh "$ExistingNodes" 100000
	Target=0
	WRatio=0
	if [ $Limit -eq 100000 ];
	then
	    RebalanceTime=$((3600/10))
	    TotalTime=$((RebalanceTime+BeforeRebalance+AfterRebalance))
	else
	    RebalanceTime=$((4300000/Limit))
	    TotalTime=$((RebalanceTime+BeforeRebalance+AfterRebalance))
	fi
	sudo ./scripts/parallelCommand.sh "sudo iptables -A OUTPUT -p tcp --sport 9042"
	sudo ./scripts/parallelCommand.sh "$ExistingNodes" "sudo iptables -A OUTPUT -p tcp --sport 7000"
	sudo ./scripts/parallelCommand.sh "$NodesToAdd" "sudo iptables -A INPUT -p tcp --sport 7000"
	./scripts/checkPortStat.sh "$AllNodes" $TotalTime $Folder & 
	./scripts/checkNodetoolStat.sh "$AllNodes" $TotalTime $Folder & 
	TotalTS=$((TotalTime/10))
	sudo ./scripts/getDStat.sh $TotalTS &
	sudo ./scripts/nohup_to_all.sh "./getDStat.sh $TotalTS"
	touch $Folder/$Limit"M"
	echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
	#./scripts/command_to_all.sh "$AllNodes" "nodetool setstreamthroughput $Limit"
	./scripts/setRequestBand.sh "$ExistingNodes" $Limit 
	#./scripts/testRebalanceStatus.sh $Folder &
	./scripts/runWorkload.sh "$AllNodes" $Folder $WRatio $Target $TotalTime &
	sleep $BeforeRebalance

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
	sudo ./scripts/copyFromAll.sh localhost-dstat ~ $Folder 
done
