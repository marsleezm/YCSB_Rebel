#!/bin/bash

Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/generate3D.sh > $LogFolder/3D

Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/generate3D.sh > $LogFolder/3D

Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/generate3D.sh > $LogFolder/3D
exit

Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/rebalanceTime.sh 900 280  > $LogFolder/rebalance


Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/rebalanceTime.sh 300 75 > $LogFolder/rebalance

Time=`date +'%Y-%m-%d-%H:%M:%S'`
LogFolder=logs/$Time
mkdir $LogFolder 
scripts/rebalanceTime.sh 300 80 > $LogFolder/rebalance
