#!/bin/bash

Command1="cat /sys/class/net/eth0/statistics/rx_bytes"
Command2="cat /sys/class/net/eth0/statistics/tx_bytes"
File=$1"/$2_netinfo"
FirstNode=`head -1 ./scripts/allnodes`
AllNodes=`cat ./scripts/allnodes`
echo "$Result"
for Node in ${AllNodes}
do
    RX=`ssh -i key ubuntu@$Node "$Command1"`
    TX=`ssh -i key ubuntu@$Node "$Command2"`
    echo $Node $RX $TX >> $File
done
