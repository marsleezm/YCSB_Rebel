#!/bin/bash

First=`head -1 ./scripts/allnodes`
for node in `cat ./scripts/allnodes`
do
IP=$node
Tmp=${IP//./-}
HostName=ip-$Tmp
ReplaceHost="sudo sed -i -e \"s/172.30.0.141/$IP/g\" /etc/hosts"
AppendHost="echo $IP $HostName | sudo tee --append /etc/hosts"
AddToCassandra="sudo sed -i -e "s/172.30.0.141/$IP/g" /etc/cassandra/cassandra-env.sh"
ReplaceSeed="sudo sed -i -e "s/172.30.0.141/$First/g" /etc/cassandra/cassandra.yaml"

./scripts/command_to_all.sh $node "$ReplaceHost"
./scripts/command_to_all.sh $node "$AppendHost"
./scripts/command_to_all.sh $node "$AddToCassandra"
./scripts/command_to_all.sh $node "$ReplaceSeed"
done
