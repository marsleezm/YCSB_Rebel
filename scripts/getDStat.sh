#!/bin/bash

A=`pgrep java`
Ip=`echo marco | sudo -S hostname --ip-address`
sudo dstat -c -d -l --output "./$Ip-dstat" 10 $1
