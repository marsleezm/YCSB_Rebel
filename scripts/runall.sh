#!/bin/bash
Time=`date +'%Y-%m-%d-%H:%M:%S'`
Folder="results/$Time"
mkdir $Folder
echo "Current folder: $Folder"
./load.sh
#./linear.sh $Folder
#echo "Stable workload finished.."
./addNode.sh
#echo "Added node"
#./increase.sh  $Folder
#echo "increase workload finished.."
./linear.sh $Folder
#echo "Stable workload finished.."
