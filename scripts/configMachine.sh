#!/bin/bash
set -e

if [ $# -eq 1 ]
then
    Nodes=$1
else
    Nodes=`cat ./scripts/allnodes`
fi
First=`head -1 ./scripts/allnodes`
for node in $Nodes 
do
IP=$node
#Change 127.0.0.1 localhost in hosts to $IP localhost. It's done in the following way because command_to_all replaces
#'localhost' with IP, so it doens't work properly..
YAML="/etc/cassandra/cassandra.yaml"
ENV="/etc/cassandra/cassandra-env.sh"
ReplaceHost="sudo sed -i 's/.* local.*/$IP local/' /etc/hosts && sudo sed -i '1s/$/host/' /etc/hosts"
ReplaceHostName="sudo sed -i 's/.* -Djava.rmi.server.hostname=.*/JVM_OPTS=\x22$JVM_OPTS -Djava.rmi.server.hostname=$IP\x22/g' /etc/cassandra/cassandra-env.sh"
#Increase read/write timeout
IncreaseTimeout="sudo sed -i 's/write_request_timeout_in_ms: .*/write_request_timeout_in_ms: 100000/' $YAML && 
		sudo sed -i 's/read_request_timeout_in_ms: .*/read_request_timeout_in_ms: 50000/' $YAML"
ReduceMemtableSize="sudo sed -i 's/.*memtable_total_space_in_mb: .*/memtable_total_space_in_mb: 150/' $YAML" 
IncreaseMemtableWriter="sudo sed -i 's/.*memtable_flush_writers: .*/memtable_flush_writers: 2/' $YAML" 
#Concurrent="sudo sed -i 's/.*concurrent_reads: .*/concurrent_reads: 48/' $YAML && sudo sed -i 's/.*concurrent_writes: .*/concurrent_writes: /' $YAML" 
#ReduceDiskSync="sudo sed -i 's/commitlog_sync_period_in_ms: .*/commitlog_sync_period_in_ms: 2000/' $YAML" 
#ReducePendingCommit="sudo sed -i 's/.*commitlog_periodic_queue_size.*/commitlog_periodic_queue_size: 600/' $YAML" 
ChangeHeapSize="sudo sed -i 's/#MAX_HEAP_SIZE.*/MAX_HEAP_SIZE=\x221G\x22/' $ENV" 
ChangeNewHeap="sudo sed -i 's/#HEAP_NEWSIZE.*/HEAP_NEWSIZE=\x22300M\x22/' $ENV" 
#Change cluster name
ChangeName="sudo sed -i 's/cluster_name: .*/cluster_name: \x27Rebel\x27/g' $YAML"
#Replace seed
ReplaceSeed="sudo sed -i 's/- seeds: .*/- seeds: \x22$First\x22/g' $YAML"
#Create data folder if there is no
CreateDataFolder="sudo chmod 777 /mnt && sudo mkdir -p /mnt/cassandra_data/commitlog && sudo mkdir -p /mnt/cassandra_data/data && sudo mkdir -p /mnt/cassandra_data/saved_caches && sudo chmod 777 -R /mnt && sudo chown -R cassandra:cassandra /mnt/cassandra_data"
#Replace listen address
ReplaceListenAddr="sudo sed -i 's/listen_address:.*/listen_address: $IP/g' $YAML"
InstallDStat="sudo apt-get -y install dstat"

./scripts/parallelCommand.sh $node "$ReplaceHost"
./scripts/parallelCommand.sh $node "$ReplaceHostName"
./scripts/parallelCommand.sh $node "$IncreaseTimeout"
./scripts/parallelCommand.sh $node "$ChangeName"
./scripts/parallelCommand.sh $node "$ReplaceSeed"
./scripts/parallelCommand.sh $node "$ChangeHeapSize"
./scripts/parallelCommand.sh $node "$ChangeNewHeap"
./scripts/parallelCommand.sh $node "$ReduceMemtableSize"
./scripts/parallelCommand.sh $node "$CreateDataFolder"
./scripts/parallelCommand.sh $node "$IncreaseMemtableWriter"
#./scripts/parallelCommand.sh $node "$Concurrent"
#./scripts/parallelCommand.sh $node "$ReducePendingCommit"
./scripts/parallelCommand.sh $node "$ReplaceListenAddr"
./scripts/parallelCommand.sh $node "$InstallDStat"
done
