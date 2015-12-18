#!/bin/bash
Host=$1
count=1

Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
while [[  $Result == "Not sending any streams." ]]; do
        echo "Not started yet"
        sleep 5 
	count=$((count + 1))
        Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
done
echo "Rebalanced started."
