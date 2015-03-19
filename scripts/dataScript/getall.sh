#!/bin/bash

Files=$1
for File in $Files
  do
   echo $File
   ~/YCSB/scripts/dataScript/getlatency.sh $File
done
