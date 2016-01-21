#!/bin/bash

A=`pgrep java`
Ip=`hostname --ip-address`
sudo -u cassandra jstat -gcutil -t $A 10s $1 > $Ip-gc
