#!/bin/bash

set -e
USER=`cat ./scripts/user`
Hosts=$1
Duration=$2
Folder=$3
Port1=7000
Port2=9042
CurrentTime=`date +%s` 
NextTime=$CurrentTime
FinalTime=$((Duration+CurrentTime))
echo $FinalTime
while [[  $CurrentTime -le $FinalTime ]]; do
	CurrentTime=`date +%s`
	if [[ $CurrentTime -ge $NextTime ]]
	then
		NextTime=$((NextTime+10))
		for Host in ${Hosts}
		do
			Time=`date +'%Y%m%d-%H%M%S'`
			Result1=`ssh $USER@$Host -X -i key "echo marco | sudo -S iptables -L -n -v -x | grep spt:$Port1"`
			echo "$Time: $Result1" >> $Folder/$Host-$Port1
			Result2=`ssh $USER@$Host -X -i key "echo marco | sudo -S iptables -L -n -v -x | grep spt:$Port2"`
			echo "$Time: $Result2" >> $Folder/$Host-$Port2
		done
	fi
	sleep 1 
done
