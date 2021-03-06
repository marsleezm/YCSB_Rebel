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
echo "Existing nodes are " "$ExistingNodes" ", nodes to add are " "$NodesToAdd"
AllNodes=$ExistingNodes" "$NodesToAdd
TotalBandwidth=100
Limit=10
#Baseline time is the time for rebalance under baseline limit
BaseLineLimit=10
BaseLineTime=50
WRatio=0
#Targets=(50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850)
Target=1400
NoRebTarget=700

#Re-config time
C0="sudo tc qdisc del root dev eth0"
./scripts/command_to_all.sh "$C0"

Limits=(1 2 4 10)
Targets=(1000 1300 1600)
for Limit in ${Limits[@]}
do
    for Target in ${Targets[@]}
    do
	Time=`date +'%Y%m%d%H%M%S'`
	Folder="results/$Time-3D"
	mkdir $Folder
	./scripts/stopNodes.sh "$AllNodes"
	./scripts/startNodes.sh "$ExistingNodes"
	echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
	EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit / Limit))
	#RequestLimit=$((TotalBandwidth - Limit))
	RequestLimit=$TotalBandwidth
	./scripts/checkRebalanceTime.sh $Limit $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder $EstRebalanceDuration $RequestLimit
	sleep 600
    done
done

sleep 600
T=(1000 1500 2000)
for TT in ${T[@]}
do
	Time=`date +'%Y%m%d%H%M%S'`
	Folder="results/$Time-3D"
	mkdir $Folder
	./scripts/stopNodes.sh "$AllNodes"
	./scripts/startNodes.sh "$ExistingNodes"
	EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit/Limit ))
	echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$TT"op/s."
	./scripts/loadAndBenchmark.sh $TotalBandwidth $WRatio $TT "$ExistingNodes" "$NodesToAdd" $Folder $EstRebalanceDuration
	sleep 600
done
exit


Time=`date +'%Y%m%d%H%M%S'`
Folder="results/$Time-3D"
mkdir $Folder
Limit=10
./scripts/configRequestBand.sh
./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit/Limit ))
RequestLimit=$((TotalBandwidth - Limit))
./scripts/checkRebalanceTime.sh $Limit $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder $EstRebalanceDuration $RequestLimit

Time=`date +'%Y%m%d%H%M%S'`
Folder="results/$Time-3D"
mkdir $Folder
./scripts/configRequestBand.sh
./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit/10))
./scripts/checkRebalanceTime.sh 0 $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder $EstRebalanceDuration $TotalBandwidth 
