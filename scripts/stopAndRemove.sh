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
rmVarData="sudo rm -rf /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches"
rmData="sudo rm -rf /mnt/cassandra_data/data /mnt/cassandra_data/commitlog /mnt/cassandra_data/saved_caches"
$Folder/scripts/parallelCommand.sh "$Nodes" "$stopC"
$Folder/scripts/parallelCommand.sh "$Nodes" "$rmData"
$Folder/scripts/parallelCommand.sh "$Nodes" "$rmVarData"
echo "Stopped nodes."
