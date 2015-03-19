#!/bin/bash

set -e
startC="sudo service cassandra start"
Time=`date +'%Y-%m-%d-%H:%M:%S'`
echo "Adding nodes:$1"
echo 'Time of adding nodes: '$Time
#startC="nohup java -jar kv-3.0.14/lib/kvstore.jar start -root kv-3.0.14/data > /dev/null 2>&1 &"
#./command_to_all.sh "$killC"
for node in $1
do
	nohup ssh -t -i key ubuntu@$node "$startC"
done
echo "Sleep 8 seconds for cassandra to awake"
sleep 8 
#./scripts/checkNodeTool.sh "$1"
