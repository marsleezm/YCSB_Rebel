#!/bin/bash

rm tmp
touch tmp
while read Line
do
    if [[ $Line == 10* ]]
    then    
	Str=($Line)
	echo ${Str[7]} >> tmp	
    else
	echo $Line >> tmp
    fi
done < $1
cat tmp > $1
