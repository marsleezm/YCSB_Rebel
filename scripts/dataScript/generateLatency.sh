#!/bin/bash

Folder=$1
WD=`pwd`
cd $Folder
Files=`ls`
for File in $Files
do
  if [[ ! "$File" =~ "update" &&  ! "$File" =~ "read" ]]; then
   $WD/extractLatency.sh $File
  fi
done
$WD/mergeLatency.sh update
$WD/mergeLatency.sh read 
