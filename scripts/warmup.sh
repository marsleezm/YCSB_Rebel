#!/bin/bash
HOST="$1"
WRatio=$2
RRatio=$(echo "1-$WRatio" | bc -l)
OPCount=$3

echo "Benchmarking nodes:" "$HOST" "Operation count is "$OPCount, "ReadRatio="$RRatio" WriteRatio="$WRatio
bin/ycsb run cassandra-cql -p host="$HOST"  -threads 30 -p updateproportion=$WRatio -p readproportion=$RRatio -p operationcount=$OPCount -P workloads/cassandraworkload -s 
