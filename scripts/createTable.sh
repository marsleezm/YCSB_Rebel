#!/bin/bash

set -e
if [ $# -eq 1 ]
then 
	Node=$1
else
	Node=`cat scripts/allnodes | head -1`
fi
./scripts/copyToAll.sh ./scripts/createtable.txt
createTable="cqlsh -f createtable.txt"
./scripts/command_to_all.sh "$Node" "$createTable"
