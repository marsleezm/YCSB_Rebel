#!/bin/bash

FAIL=0
echo $command" for nodes:"$nodes 
if [ $# -eq 1 ]
then
    nodes=`cat ./scripts/allnodes`
    file=$1
else
    nodes=$1
    file=$2
fi
for node in $nodes
do
   scp -i key $file ubuntu@$node: & 
done

for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done
