#!/bin/bash

set -e
USER=`cat ./scripts/user`
startC="sudo service cassandra start"
Time=`date +'%Y-%m-%d-%H:%M:%S'`
echo "Adding nodes:$1"
echo 'Time of adding nodes: '$Time
for node in $1
do
	nohup ssh -t -i key $USER@$node "$startC"
done
echo "Sleep 8 seconds for cassandra to awake"
sleep 8 
#./scripts/checkNodeTool.sh "$1"
