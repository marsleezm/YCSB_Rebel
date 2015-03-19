#!/bin/bash

nodes=`cat ./scripts/allnodes`
C0="sudo tc qdisc del root dev eth0" 
C1="sudo tc qdisc add dev eth0 root handle 1: htb default 10" 
C2="sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 400mbit burst 800m" 
C3="sudo tc class add dev eth0 parent 1:1 classid 1:10 htb rate 400mbit burst 800m prio 1" 
C4="sudo tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10"
C5="sudo iptables -A OUTPUT -t mangle -p tcp --sport 9042 -j MARK --set-mark 10"
C6="sudo tc filter add dev eth0 parent 1:0 prio 0 protocol ip handle 10 fw flowid 1:10"
./scripts/command_to_all.sh "$nodes" "$C0"
./scripts/command_to_all.sh "$nodes" "$C1"
./scripts/command_to_all.sh "$nodes" "$C2"
./scripts/command_to_all.sh "$nodes" "$C3"
./scripts/command_to_all.sh "$nodes" "$C4"
./scripts/command_to_all.sh "$nodes" "$C5"
./scripts/command_to_all.sh "$nodes" "$C6"
