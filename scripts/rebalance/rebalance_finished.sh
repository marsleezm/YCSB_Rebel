#!/bin/bash
Host=$1
Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
while [[  $Result != "Not sending any streams." ]]; do
        echo "Transferring data..."
	sleep 10
        Result=`ssh ubuntu@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
done
