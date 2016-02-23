#!/bin/bash

echo "$1" > ./to_load
sudo ./scripts/copy_to_all.sh ./to_load ./YCSB_Rebel
OtherNodes=`cat ./scripts/loaders`
OtherNodeNum=`cat ./scripts/loaders | wc -l`
AvgToLoad=$((${2}/(OtherNodeNum+1)))
./scripts/parallelCommand.sh "cd YCSB_Rebel && ./scripts/load.sh $2"

