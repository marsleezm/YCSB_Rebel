#!/bin/bash

set -e 
USER=`cat ./scripts/user`
#NodeToAdd=`tail -1 ./scripts/allnodes`
#./scripts/stopNodes.sh $NodeToAdd 
#./scripts/configMachine.sh $NodeToAdd 
#rmData="sudo rm -rf /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches"
#./scripts/command_to_all.sh $NodeToAdd "$rmData"
#./scripts/addNode.sh $NodeToAdd 

Folder=$1

for I in `seq 1 300`
do
	Command1="cat /sys/class/net/eth0/statistics/rx_bytes"
	Command2="cat /sys/class/net/eth0/statistics/tx_bytes"
	Command4="du -ch /var/lib/cassandra/data | tail -1"
	AllNodes=`cat ./scripts/allnodes`
	for Node in ${AllNodes}
	do
	    File=$Folder/$Node
	    RX=`ssh -i key $USER@$Node "$Command1"`
	    TX=`ssh -i key $USER@$Node "$Command2"`
	    DiskStat=`ssh -i key $USER@$Node "$Command4"`
	    Data=($DiskStat)
	    echo $Node $RX $TX ${Data[0]} >> $File
	done
	sleep 10
done
