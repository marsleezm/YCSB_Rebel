#!/bin/bash

Folder=$1
BaseTime=0
OutputFile="operation"
cd $Folder
rm $OutputFile
rm tmp
Files=`ls 2014*`
for File in $Files
do
  echo $File
  cat $File| grep "current ops" > tmp
  while read Line
   do
	 #echo $Line
	 IFS=';:' read -ra ARR <<< "$Line"
	 TimeArr=(${ARR[0]})
	 LocalTime=${TimeArr[0]}
	 RealTime=$((BaseTime+LocalTime))
	 Op=(${ARR[2]})
	 CumOp=${Op[0]} 
	 PrevTime=$RealTime
	 echo "$RealTime, ${CumOp}" >> $OutputFile
  done < tmp
  BaseTime=$RealTime
  echo $BaseTime
done
