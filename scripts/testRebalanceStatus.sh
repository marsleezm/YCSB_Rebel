#!/bin/bash

set -e 
#NodeToAdd=`tail -1 ./scripts/allnodes`
#./scripts/stopNodes.sh $NodeToAdd 
#./scripts/configMachine.sh $NodeToAdd 
#rmData="sudo rm -rf /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches"
#./scripts/command_to_all.sh $NodeToAdd "$rmData"
#./scripts/addNode.sh $NodeToAdd 

Time=`date +'%Y-%m-%d-%H:%M:%S'`
Folder="results/"$Time
mkdir $Folder

for I in `seq 1 100`
do
	Command1="cat /sys/class/net/eth0/statistics/rx_bytes"
	Command2="cat /sys/class/net/eth0/statistics/tx_bytes"
	Command4="du -ch /var/lib/cassandra/data | tail -1"
	AllNodes=`cat ./scripts/allnodes`
	for Node in ${AllNodes}
	do
	    File=$Folder/$Node
	    RX=`ssh -i key ubuntu@$Node "$Command1"`
	    TX=`ssh -i key ubuntu@$Node "$Command2"`
	    DiskStat=`ssh -i key ubuntu@$Node "$Command4"`
	    Data=($DiskStat)
	    echo $Node $RX $TX ${Data[0]} >> $File
	done
	sleep 5
done
