#!/bin/bash

First=`head -1 ./scripts/allnodes`
for node in `cat ./scripts/allnodes`
do
IP=$node
#Change 127.0.0.1 localhost in hosts to $IP localhost. It's done in the following way because command_to_all replaces
#'localhost' with IP, so it doens't work properly..
YAML="/etc/cassandra/cassandra.yaml"
ReplaceHost="sudo sed -i 's/.* local.*/$IP local/' /etc/hosts && sudo sed -i '1s/$/host/' /etc/hosts"
ReplaceHostName="sudo sed -i 's/.* -Djava.rmi.server.hostname=.*/JVM_OPTS=\x22$JVM_OPTS -Djava.rmi.server.hostname=$IP\x22/g' /etc/cassandra/cassandra-env.sh"
#Increase read/write timeout
IncreaseTimeout="sudo sed -i 's/write_request_timeout_in_ms: .*/write_request_timeout_in_ms: 20000/' $YAML && 
		sudo sed -i 's/read_request_timeout_in_ms: .*/read_request_timeout_in_ms: 20000/' $YAML"
#Change cluster name
ChangeName="sudo sed -i 's/cluster_name: .*/cluster_name: \x27Rebel\x27/g' $YAML"
#Replace seed
ReplaceSeed="sudo sed -i 's/- seeds: .*/- seeds: \x22$First\x22/g' $YAML"
#Replace listen address
ReplaceListenAddr="sudo sed -i 's/listen_address:.*/listen_address: $IP/g' $YAML"

./scripts/command_to_all.sh $node "$ReplaceHost"
./scripts/command_to_all.sh $node "$ReplaceHostName"
./scripts/command_to_all.sh $node "$IncreaseTimeout"
./scripts/command_to_all.sh $node "$ChangeName"
./scripts/command_to_all.sh $node "$ReplaceSeed"
./scripts/command_to_all.sh $node "$ReplaceListenAddr"
done
