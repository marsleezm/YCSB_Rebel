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
NodesToAdd=`head -2 scripts/allnodes | tail -1`
AllNodes=$ExistingNodes" "$NodesToAdd
TotalBandwidth=120
RebalanceLimit=(30)
BaseLineTime=300
WRatio=(0.05)
#Targets=(50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850)
Targets=(0)
Time=`date +'%Y-%m-%d-%H:%M:%S'`
Folder="results/$Time-3D"
mkdir $Folder
echo "Output to "$Folder

for Ratio in ${WRatio[@]}; do
    for Limit in ${RebalanceLimit[@]}; do
	for Target in ${Targets[@]}; do
		./scripts/configRequestBand.sh
		./scripts/stopNodes.sh "$AllNodes"
		./scripts/startNodes.sh "$ExistingNodes"
		echo "Rebalance limit: "$Limit", Write Ratio: "$Ratio", Operation target: "$Target"op/s."
		Duration=$(( BaseLineTime*40/Limit/3 ))
		RequestLimit=$((TotalBandwidth - Limit))
		./scripts/checkRebalanceTime.sh $Limit $Ratio $Target "$ExistingNodes" "$NodesToAdd" $Folder $Duration $RequestLimit
	done
	echo "Continuing limit..."
    done
    echo "Continuing ratio..."
done
