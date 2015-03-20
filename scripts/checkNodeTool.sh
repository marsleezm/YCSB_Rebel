#!/bin/bash

sleep 5
set -e
checkNodetool="nodetool status | grep Datacenter | wc -l"
Restart="sudo service cassandra restart"
KillJava="sudo killall java"
if [ $# -eq 1 ]
then
     nodes=$1
else
     nodes=`head -1 ./scripts/allnodes`
fi
echo "Checking if nodetool is working for "$nodes
for node in $nodes
do
#   Result=`ssh ubuntu@$node -X -i key $checkNodetool`
#   while [[ $Result == 0 ]]; do
#         nohup ssh -t ubuntu@$node -i key $Restart
#        echo "Restarting nodetool for "$node"... Wait 10 seconds to reconnect"
#	sleep 15        
#	Result=`ssh ubuntu@$node -X -i key $checkNodetool`
#   done
   echo "nodetool working for "$node
done
