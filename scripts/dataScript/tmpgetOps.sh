#!/bin/bash

Files="../results/*"
OutputFile="op_output"
rm $OutputFile
lineNumber=10
OverallTime=0
for File in $Files
do
	echo $File
	Line=`awk "NR == $lineNumber" "$File"`
	IFS=';' read -ra ARR <<< "$Line"
	IFS=':' read -ra ARR2 <<< "$ARR"
	Numbers=(${ARR2[0]})
	Number=${Numbers[0]}
	OverallTime=$((OverallTime+=Number))
	Op=(${ARR2[1]})
	echo $Op
	echo "$OverallTime, ${Op[0]}" >> $OutputFile
done
