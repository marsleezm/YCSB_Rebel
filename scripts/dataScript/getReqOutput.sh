#!/bin/bash

Folder=$1
OutputFile="operation"
cd $Folder
rm *-diff 
Files=`ls 10*`
for File in $Files
do
  echo $File
  LP=0
  LD=0
  NewFile=$File-diff
  while read Line
   do
	 #echo $Line
	 IFS=' ' read -ra ARR <<< "$Line"
         #echo ${#ARR[@]}
	 if [[ ${#ARR[@]} -gt 5  ]]
	 then 
	     CP=${ARR[5]}
	     CD=${ARR[7]}
	     echo ${ARR[0]} $((CP-LP)) $((CD-LD)) >> $NewFile 
	 else
	     echo ${ARR[@]} >> $NewFile
	 fi 
	 LP=$CP
	 LD=$CD
#	 TimeArr=(${ARR[0]})
#	 LocalTime=${TimeArr[0]}
#	 RealTime=$((BaseTime+LocalTime))
#	 Op=(${ARR[2]})
#	 CumOp=${Op[0]} 
#	 PrevTime=$RealTime
#	 echo "$RealTime, ${CumOp}" >> $OutputFile
  done < $File 
  #BaseTime=$RealTime
  #echo $BaseTime
done
