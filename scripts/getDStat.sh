#!/bin/bash

A=`pgrep java`
Ip=`hostname --ip-address`
dstat -c -d -l 10 $1 --output $IP-dstat
