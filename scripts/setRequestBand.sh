#!/bin/bash

if [ $# -eq 1 ]
then
    nodes=`cat ./scripts/allnodes`
    limit=$1
else
    nodes=$1
    limit=$2
fi
echo "Request speed limit: "$limit "mb/s"
command="sudo tc class change dev eth0 parent 1: classid 1:1 htb rate ${limit}kbps ceil ${limit}kbps prio 1"
./scripts/command_to_all.sh "$nodes" "$command"
