#!/bin/bash

A=`pgrep java`
Ip=`sudo hostname --ip-address`
sudo dstat -c -d -l --output "./$Ip-dstat" 10 $1
