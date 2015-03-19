#!/bin/bash

BaseTime=0
OutputFile=$1
rm $OutputFile
rm tmp
rm tmp2
Files=`ls *$1`
echo $Files
for File in $Files
do
  echo $File
  while read Line
   do
	 IFS=',' read -ra ARR <<< "$Line"
	 TimeInMicro=(${ARR[0]})
	 if [[ $TimeInMicro == 0 ]]
	   then 
		LocalTime=0
	 else
	  	LocalTime=$((TimeInMicro / 1000))
	 fi
	 RealTime=$((BaseTime + LocalTime))
	 Latency=(${ARR[1]})
	 echo "$RealTime, $Latency" >> $OutputFile
  done < $File 
  BaseTime=$((RealTime+1))
  echo $BaseTime
done
echo "Total count: $BaseTime"
