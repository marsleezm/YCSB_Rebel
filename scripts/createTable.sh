#!/bin/bash

set -e
if [ $# -eq 1 ]
then 
	Node=$1
else
	Node=`cat scripts/allnodes | head -1`
fi
FOLDER=`pwd`
./scripts/copyToAll.sh ./scripts/createtable.txt
createTable="sudo cqlsh -f createtable.txt"
$FOLDER/scripts/command_to_all.sh "$Node" "$createTable"
