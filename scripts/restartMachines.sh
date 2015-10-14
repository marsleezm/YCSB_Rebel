#!/bin/bash

set -e
if [ $# -eq 1 ]
then
	Nodes=$1
else
	Nodes=`cat scripts/allnodes`
fi
echo "Restaring all machines:"$Nodes 
restartM="sudo reboot"
./scripts/parallelCommand.sh "$Nodes" "$restartM"
echo "Waiting for machine to get rebooted"
sleep 60 
