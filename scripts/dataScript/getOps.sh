#!/bin/bash

Folder=$1
BaseTime=0
cd $Folder
rm tmp
Files=`ls *throughput`
for File in $Files
do
  echo $File
  OutputFile=${File%-*}"-Op"
  echo $OutputFile
  cat $File| grep "current ops" > tmp
  while read Line
   do
	 #echo $Line
	 IFS=';:' read -ra ARR <<< "$Line"
	 TimeArr=(${ARR[0]})
	 LocalTime=${TimeArr[0]}
	 Op=(${ARR[2]})
	 CumOp=${Op[0]} 
	 echo "$LocalTime, ${CumOp}" >> $OutputFile
  done < tmp
done
