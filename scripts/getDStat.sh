#!/bin/bash

A=`pgrep java`
Ip=`hostname --ip-address`
dstat -c -d -l --output $IP-dstat 10 $1
