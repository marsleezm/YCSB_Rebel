#!/bin/bash

Command1="nodetool ring"
File=$1"/$2_ringinfo"
FirstNode=`head -1 ./scripts/allnodes`
AllNodes=`cat ./scripts/allnodes`
Result=`ssh -i key ubuntu@$FirstNode "$Command1"`
echo "$Result"
for Node in ${AllNodes}
do
    Tokens=`echo "$Result" | grep $Node`
    TokenNum=`echo "$Tokens" | wc -l`
    NetworkUsg=`echo "$Tokens" | head -1 | awk '{print $5 $6}'`
    TokenLine=`echo "$Tokens" | awk '{print $1 " " $8}'`
    echo "$TokenLine" >> $File
    echo $NetworkUsg $TokenNum >> $File
done
