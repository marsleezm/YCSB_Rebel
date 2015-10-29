#!/bin/bash
Hosts=$1
Duration=$2
Folder=$3
Timer=0
while [[  $Timer -le $Duration ]]; do
	for Host in ${Hosts}
	do
		Time=`date +'%Y%m%d-%H%M%S'`
        	Result=`ssh ubuntu@$Host -X -i key "sudo iptables -L -n -v -x | grep OUTPUT"`
		echo "$Time: $Result" >> $Folder/$Host
	done
	sleep 5
	Timer=$((Timer+5))
done
