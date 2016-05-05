#!/bin/bash

pids=$(ps -eLo nice,tid,args |awk '/^ *0 .*java/{print $2}')
for pid in $pids; do echo marco | sudo -S taskset -pc 2,4 $pid; done
