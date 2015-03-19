#!/bin/bash

set -e
if [ $# -eq 1 ]
then
	Nodes=$1
else
	Nodes=`cat scripts/allnodes`
fi
FirstNode=($Nodes)
FirstNode=${FirstNode[0]}
Folder=`pwd`
echo "Starting all nodes:"$Nodes 
startC="sudo service cassandra start"
$Folder/scripts/command_to_all.sh "$Nodes" "$startC" 
echo "Sleeping for 15 seconds..."
sleep 15
#./scripts/checkNodeTool.sh "$Nodes"
#sleep 10
./scripts/createTable.sh "$FirstNode"

echo "Successfully started Cassandra"
