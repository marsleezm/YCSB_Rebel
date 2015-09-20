#!/bin/bash

First=`head -1 ./scripts/allnodes`
for node in `cat ./scripts/allnodes`
do
IP=$node
#Change 127.0.0.1 localhost in hosts to $IP localhost
ReplaceHost="sudo sed -i 's/.* localhost/$IP localhost/g' /etc/hosts"
#I don't remember what this is for.. WTF?
AddToCassandra="sudo sed -i -e "s/172.30.0.141/$IP/g" /etc/cassandra/cassandra-env.sh"
#Change cluster name
ChangeName="sudo sed -i 's/cluster_name: .*/cluster_name: \x27Rebel\x27/g' /etc/cassandra/cassandra.yaml"
#Replace seed
ReplaceSeed="sudo sed -i 's/- seeds: .*/- seeds: \x22$IP\x22/g' /etc/cassandra/cassandra.yaml"
#Replace listen address
ReplaceListenAddr="sudo sed -i 's/listen_address:.*/listen_address: $IP/g' /etc/cassandra/cassandra.yaml"

./scripts/command_to_all.sh $node "$ReplaceHost"
#./scripts/command_to_all.sh $node "$AddToCassandra"
./scripts/command_to_all.sh $node "$ChangeName"
./scripts/command_to_all.sh $node "$ReplaceSeed"
./scripts/command_to_all.sh $node "$ReplaceListenAddr"
done
