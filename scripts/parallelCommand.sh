#!/bin/bash

FAIL=0
if [ $# -eq 1 ]
then
    nodes=`cat ./scripts/allnodes`
    command=$1
else
    nodes=$1
    command=$2
fi
echo $command" for nodes:"$nodes 
for node in $nodes
do
   ssh -t ubuntu@$node -i key ${command/localhost/$node} & 
done

for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
echo "$command finished." 
else
echo "Fail! ($FAIL)"
fi
