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
for node in $Nodes
do
$Folder/scripts/command_to_all.sh "$node" "$startC" 
sleep 50
done
echo "Sleeping for 15 seconds..."
#./scripts/checkNodeTool.sh "$Nodes"
#sleep 10
./scripts/createTable.sh "$FirstNode"

echo "Successfully started Cassandra"
