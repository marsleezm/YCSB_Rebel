#!/bin/bash

#Compare network usage diff
File1=$1"/start_netinfo"
File2=$1"/end_netinfo"
Output=$1"/summary_netinfo"
Index=1
while read Line2 
do
    Line1=`awk "NR==$Index" $File1`
    Line1Str=($Line1)
    Line2Str=($Line2)
    Diff1=`expr ${Line2Str[1]} - ${Line1Str[1]}`
    Diff2=`expr ${Line2Str[2]} - ${Line1Str[2]}`
    echo ${Line1Str[0]} $Diff1 $Diff2 ${Line1Str[3]} ${Line2Str[3]} >> $Output
    ((Index++)) 
done < $File2

File1=$1"/start_ringinfo"
File2=$1"/end_ringinfo"
Output=$1"/summary_ringinfo"

for Node in `cat ./scripts/allnodes`
do
    cat $File1 | grep --line-buffered "$Node" > ./tmp1
    cat $File2 | grep --line-buffered "$Node" > ./tmp2
    Diff=`diff -y --suppress-common-lines tmp1 tmp2 | grep '^' | wc -l`
    echo $Node $Diff >> $Output
done
