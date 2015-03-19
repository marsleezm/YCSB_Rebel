#!/bin/bash
Host=$1
count=1

Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
while [[  $Result == "Not sending any streams." ]]; do
        echo "Not started yet"
        sleep 0.5 
	count=$((count + 1))
        Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
	if [ "$((count%40))" -eq "0" ]
	then
		nohup ssh -t ubuntu@$Host -i key "sudo service cassandra restart"	
	fi
done
echo "Rebalanced started."
