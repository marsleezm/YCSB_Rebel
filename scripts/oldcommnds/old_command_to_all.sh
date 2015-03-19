#!/bin/bash

FAIL=0
command=$1
if [ $# -eq 1 ]
then
    nodes=`cat ./scripts/nodes`
elif [ $# -eq 2 ]
then
    nodes=`head -$2 ./scripts/nodes`
else
    nodes=`awk "NR==$2" ./scripts/nodes | cat`
fi
for node in $nodes
do
   ssh -t -t -oStrictHostKeyChecking=no ubuntu@$node -X -i ~/id_rsa_clo ${command/localhost/$node} &
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
