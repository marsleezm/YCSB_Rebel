#!/bin/bash

set -e
if [ $# -eq 1 ]
then 
	Node=$1
else
	Node=`cat scripts/allnodes | head -1`
fi
FOLDER=`pwd`
createTable="sudo cqlsh -f createtable.txt"
$FOLDER/scripts/command_to_all.sh "$Node" "$createTable"
