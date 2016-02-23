#!/bin/bash
Host=$1
USER=`cat ./scripts/user`
Result=`ssh $USER@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
while [[  $Result != "Not sending any streams." ]]; do
        echo "Transferring data..."
	sleep 10
        Result=`ssh $USER@$Host -X -i key "nodetool netstats" | grep "Not sending any streams."`
done
