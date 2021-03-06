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
echo "Stopping all nodes:"$Nodes 
stopC="sudo service cassandra stop"
rmData="sudo rm -rf /mnt/cassandra_data/commitlog /mnt/cassandra_data/saved_caches"
$Folder/scripts/command_to_all.sh "$Nodes" "$stopC"
$Folder/scripts/command_to_all.sh "$Nodes" "$rmData"
echo "Stopped nodes."
