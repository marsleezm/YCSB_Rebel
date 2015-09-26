#!/bin/bash

#Get overall latency
QueryResult=$(./scripts/command_to_all.sh "nodetool cfstats ycsb" 1)
tmp=$(echo "$QueryResult"|awk 'NR==4')
IFS=':' read -ra ARR <<< "$tmp"
Count=${ARR[1]}
Count=`echo $Count | tr -d '\r'`
tmp=`echo "$QueryResult"| awk 'NR==5'`
IFS=':' read -ra ARR <<< "$tmp"
tmp=${ARR[1]}
tmp=${tmp#?}
Latency=${tmp%?????}
OverallUpdate=$(echo "($Count * $Latency)" | bc -l)
echo $Latency" "$Count" "$OverallUpdate
