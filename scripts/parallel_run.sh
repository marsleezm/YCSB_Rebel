#!/bin/bash

OtherNodes=`cat ./scripts/loaders`
./scripts/parallelCommand.sh "$OtherNodes" "cd YCSB_Rebel && mkdir -p results && ./scripts/runWorkload.sh $1 results $3 $4 $5"

./scripts/copyFromAll.sh "$OtherNodes" output ./YCSB_Rebel/results/ $2


