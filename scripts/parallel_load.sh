#!/bin/bash

echo "$1" > ./to_load
OtherNodes=`cat ./scripts/loaders`
sudo ./scripts/copyToAll.sh "$OtherNodes" ./to_load ./YCSB_Rebel
OtherNodeNum=`cat ./scripts/loaders | wc -l`
AvgToLoad=$((${2}/(OtherNodeNum+1)))
./scripts/parallelCommand.sh "$OtherNodes" "cd YCSB_Rebel && ./scripts/load.sh $AvgToLoad"

