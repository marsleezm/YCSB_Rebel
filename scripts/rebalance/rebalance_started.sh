#!/bin/bash
Host=$1
count=1

USER=`cat ./scripts/user`
Result=`ssh $USER@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
while [[  $Result == "Not sending any streams." ]]; do
        echo "Not started yet"
        sleep 5 
	count=$((count + 1))
        Result=`ssh $USER@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
done
echo "Rebalanced started."
