#!/bin/bash

USER=`cat ./scripts/user`

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
   C1=${command/localhost/$node}
   C2=${C1/sudo/"echo marco | sudo -S"}
   ssh -t $USER@$node -i key $C2 & 
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
