#!/bin/bash
Host="10.20.0.117"
AddingNodes="10.20.0.118"
Limit=600
PrevLimit=600

DurationSum=0
for i in 1..3
do
	./scripts/restartNodes.sh
	./scripts/load.sh $Host > /dev/null 
	./scripts/addNode.sh $AddingNodes

	./scripts/rebalance/rebalance_started.sh "10.20.0.117" > /dev/null

	##Check that benchmark is running
	/usr/bin/time -f "%e" -o tmp ./scripts/rebalance/rebalance_finished.sh "10.20.0.117" > /dev/null
	Duration=`cat tmp`
	DurationSum=`echo $DurationSum+$Duration | bc -l`
done
MinDuration=`echo $DurationSum/3 | bc -l `
MinThreshold=`echo $MinDuration*1.1+0.5 | bc -l` 
echo $MinThreshold

i="0"
while [ $i -lt 4 ]
do
	./scripts/restartNodes.sh
	./scripts/load.sh $Host > /dev/null 
	./scripts/command_to_all.sh "$Host" "nodetool setstreamthroughput $Limit"
	./scripts/addNode.sh $AddingNodes

	./scripts/rebalance/rebalance_started.sh "10.20.0.117" > /dev/null

	##Check that benchmark is running
	/usr/bin/time -f "%e" -o tmp ./scripts/rebalance/rebalance_finished.sh "10.20.0.117" > /dev/null
	Duration=`cat tmp`

	echo $Limit", "$Duration
	
	#Threshold=${Threshold%.*}
	Longer=`echo $Duration'>'$MinThreshold | bc -l`
	if [ $Longer -eq 1 ]
	then
	   echo "Oops, break! Limit: "$Limit", previous limit: "$PrevLimit
	   break
	fi
	PrevLimit=$Limit
	Limit=$((Limit*3/4))
done

echo "Estimated capacity is: "$(( (Limit+PrevLimit)/2 ))
