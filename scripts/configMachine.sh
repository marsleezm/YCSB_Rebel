#!/bin/bash

First=`head -1 ./scripts/allnodes`
for node in `cat ./scripts/allnodes`
do
IP=$node
#Change 127.0.0.1 localhost in hosts to $IP localhost
ReplaceHost="sudo sed -i 's/.*localhost.*/$IP localhost/g' /etc/hosts"
ReplaceHostName="sudo sed -i 's/.* -Djava.rmi.server.hostname=.*/JVM_OPTS=\x22$JVM_OPTS -Djava.rmi.server.hostname=$IP\x22/g' /etc/cassandra/cassandra-env.sh"
#Change cluster name
ChangeName="sudo sed -i 's/cluster_name: .*/cluster_name: \x27Rebel\x27/g' /etc/cassandra/cassandra.yaml"
#Replace seed
ReplaceSeed="sudo sed -i 's/- seeds: .*/- seeds: \x22$First\x22/g' /etc/cassandra/cassandra.yaml"
#Replace listen address
ReplaceListenAddr="sudo sed -i 's/listen_address:.*/listen_address: $IP/g' /etc/cassandra/cassandra.yaml"

./scripts/command_to_all.sh $node "$ReplaceHost"
./scripts/command_to_all.sh $node "$ReplaceHostName"
./scripts/command_to_all.sh $node "$ChangeName"
./scripts/command_to_all.sh $node "$ReplaceSeed"
./scripts/command_to_all.sh $node "$ReplaceListenAddr"
done
