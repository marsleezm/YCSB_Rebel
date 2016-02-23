#!/bin/bash

USER=`cat ./scripts/user`
Command1="cat /sys/class/net/eth0/statistics/rx_bytes"
Command2="cat /sys/class/net/eth0/statistics/tx_bytes"
Command3="echo marco | sudo -S nodetool cfstats | awk 'NR ==9 || NR==10'"
Command4="du -ch /var/lib/cassandra/data | tail -1"

File=$1"/$2_netinfo"
FirstNode=`head -1 ./scripts/allnodes`
AllNodes=`cat ./scripts/allnodes`
echo "$Result"
for Node in ${AllNodes}
do
    RX=`ssh -i key $USER@$Node "$Command1"`
    TX=`ssh -i key $USER@$Node "$Command2"`
    #DataStat=`ssh -i key $USER@$Node "$Command3"`
    DiskStat=`ssh -i key $USER@$Node "$Command4"`
    Data=($DiskStat)
    echo $Node $RX $TX ${Data[0]} >> $File
done
