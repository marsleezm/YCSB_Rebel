#!/bin/bash

OtherNodes=`cat ./scripts/loaders`
OtherNodeNum=`cat ./scripts/loaders | wc -l`
AvgToLoad=$((${2}/(OtherNodeNum+1)))
./scripts/parallelCommand.sh "cd YCSB_Rebel && mkdir -p results && ./scripts/run_workload.sh whatever results $3 $4 $5"

./scripts/copyFromAll.sh ./YCSB_Rebel/results/output $2


