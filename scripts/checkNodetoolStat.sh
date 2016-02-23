#!/bin/bash
Hosts=$1
Duration=$2
Folder=$3
CurrentTime=`date +%s` 
NextTime=$CurrentTime
FinalTime=$((Duration+CurrentTime))
while [[  $CurrentTime -le $FinalTime ]]; do
	CurrentTime=`date +%s`
	if [[ $CurrentTime -ge $NextTime ]]
	then
		echo "Checking nodetool stat"
		NextTime=$((NextTime+30))
		for Host in ${Hosts}
		do
			Time=`date +'%Y%m%d-%H%M%S'`
			Result3=`ssh ubuntu@$Host -X -i key "echo marco | sudo -S nodetool compactionstats | grep remaining"`
			echo "$Time: $Result3" >> $Folder/$Host-compact
		done
	fi
	sleep 1 
done
