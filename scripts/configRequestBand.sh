#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# This script initialize the configuration of tc for a machine hosting
# cassandra on port 9042, which is used for serving client request by
# cassandra. The 200 mb is just dummy value. It will be changed according
# to dynamic configuration.
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nodes=`cat ./scripts/allnodes`
C="sudo modprobe sch_netem"
C0="sudo tc qdisc del root dev eth0" 
C1="sudo tc qdisc add dev eth0 root handle 1: htb default 10" 
#C2="sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 400mbit burst 800m" 
#C3="sudo tc class add dev eth0 parent 1:1 classid 1:10 htb rate 400mbit burst 800m prio 1" 
#C4="sudo tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10"
#C5="sudo iptables -A OUTPUT -t mangle -p tcp --sport 9042 -j MARK --set-mark 10"
#C6="sudo tc filter add dev eth0 parent 1:0 prio 0 protocol ip handle 10 fw flowid 1:10"
C2="sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 200mbps ceil 200mbps" 
C4="sudo tc qdisc add dev eth0 parent 1:1 handle 10: sfq perturb 10"
C5="sudo iptables -A OUTPUT -t mangle -p tcp --sport 9042 -j MARK --set-mark 10"
C6="sudo tc filter add dev eth0 protocol ip parent 1:0 prio 1 handle 10 fw flowid 1:1"
./scripts/parallelCommand.sh "$nodes" "$C"
./scripts/parallelCommand.sh "$nodes" "$C0"
./scripts/parallelCommand.sh "$nodes" "$C1"
./scripts/parallelCommand.sh "$nodes" "$C2"
#./scripts/command_to_all.sh "$nodes" "$C3"
./scripts/parallelCommand.sh "$nodes" "$C4"
./scripts/parallelCommand.sh "$nodes" "$C5"
./scripts/parallelCommand.sh "$nodes" "$C6"
