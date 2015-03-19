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
echo "Restaring all nodes:"$Nodes 
stopC="sudo service cassandra stop"
rmData="sudo rm -rf /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches"
startC="sudo service cassandra start"
$Folder/scripts/command_to_all.sh "$Nodes" "$stopC"
$Folder/scripts/command_to_all.sh "$Nodes" "$rmData"
$Folder/scripts/command_to_all.sh "$FirstNode" "$startC" 
echo "Sleeping for 15 seconds..."
sleep 15
./scripts/createTable.sh
echo "Successfully started Cassandra"
