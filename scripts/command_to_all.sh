#!/bin/bash

FAIL=0
nodes=$1
command=$2
echo $command" for nodes:"$nodes 
#if [ $# -eq 1 ]
#then
#    nodes=`cat ./scripts/nodes`
#elif [ $# -eq 2 ]
#then
#    nodes=`head -$2 ./scripts/nodes`
#else
#    nodes=`awk "NR==$2" ./scripts/nodes | cat`
#fi
for node in $nodes
do
   #nohup ssh -t ubuntu@$node -i key ${command/localhost/$node}
   nohup ssh -t ubuntu@$node -i key ${command/localhost/$node}  
   sleep 2
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
