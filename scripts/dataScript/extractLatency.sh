#!/bin/bash

File=$1
lineNumber=8
#FirstPart=${File:0:19}
#echo $FirstPart
UpdateOut=$File"-update"
ReadOut=$File"-read"
cat $File | grep UPDATE] > tmp 
ErrorLine=`grep Return tmp | wc -l`
StartLine=$((ErrorLine+5))
awk "NR > $StartLine" "tmp" > tmp2
cut -d " " -f 2- tmp2 > $UpdateOut

cat $File | grep READ] > tmp 
ErrorLine=`grep Return tmp | wc -l`
StartLine=$((ErrorLine+5))
awk "NR > $StartLine" "tmp" > tmp2
cut -d " " -f 2- tmp2 > $ReadOut
