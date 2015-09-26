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

ExistingNodes=`head -3 scripts/allnodes`
NodesToAdd=`tail -2 scripts/allnodes`
AllNodes=$ExistingNodes" "$NodesToAdd
TotalBandwidth=120
Limit=30
BaseLineTime=300
WRatio=0.05
#Targets=(50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850)
Targets=3500
Time=`date +'%Y-%m-%d-%H:%M:%S'`
Folder="results/$Time-3D"
mkdir $Folder
echo "Output to "$Folder

echo "Doing benchmakr with control"
./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
Duration=$(( BaseLineTime*40/Limit/3 ))
RequestLimit=$((TotalBandwidth - Limit))
./scripts/checkRebalanceTime.sh $Limit $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder $Duration $RequestLimit


./scripts/configRequestBand.sh
./scripts/stopNodes.sh "$AllNodes"
./scripts/startNodes.sh "$ExistingNodes"
echo "Rebalance limit: "$Limit", Write Ratio: "$WRatio", Operation target: "$Target"op/s."
Duration=$(( BaseLineTime*40/Limit/3 ))
./scripts/checkRebalanceTime.sh 200 $WRatio $Target "$ExistingNodes" "$NodesToAdd" $Folder $Duration 200 
