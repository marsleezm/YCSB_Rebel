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
NodesToAdd=`tail -1 scripts/allnodes`
echo "Existing nodes are " "$ExistingNodes" ", nodes to add are " "$NodesToAdd"
AllNodes=$ExistingNodes" "$NodesToAdd
TotalBandwidth=110
Limit=5
#Baseline time is the time for rebalance under baseline limit
BaseLineLimit=10
BaseLineTime=70
WRatio=0
#Targets=(50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850)
Target=1500

for i in `seq 1 5`;
do
echo "Doing benchmark with control"
Time1=`date +'%Y%m%d-%H%M%S'`
Folder1="results/$Time1-3D"
mkdir $Folder1
./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit/Limit ))
RequestLimit=$((TotalBandwidth - Limit))
./scripts/checkRebalanceTime.sh $Limit $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder1 $EstRebalanceDuration $RequestLimit

echo "Doing benchmark without control"
Time2=`date +'%Y%m%d-%H%M%S'`
Folder2="results/$Time2-3D"
mkdir $Folder2
./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
EstRebalanceDuration=$(( BaseLineTime*BaseLineLimit/10 ))
./scripts/checkRebalanceTime.sh 0 $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder2 $EstRebalanceDuration $TotalBandwidth 
done
