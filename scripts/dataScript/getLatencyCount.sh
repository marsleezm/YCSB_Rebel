Folder=$1
Output=$2
cd $Folder
File=`ls  --ignore="*throughput" | grep 201 | tail -1`

tmp=`cat "$File" | grep "\[UPDATE\], Operations,"`
IFS=',' read -ra ARR <<< "$tmp"
UpdateCount=${ARR[2]}
tmp=`cat "$File" | grep "\[UPDATE\], AverageLatency(us),"`
IFS=',' read -ra ARR <<< "$tmp"
UpdateLatency=${ARR[2]}

tmp=`cat "$File" | grep "\[READ\], Operations,"`
IFS=',' read -ra ARR <<< "$tmp"
ReadCount=${ARR[2]}
tmp=`cat "$File" | grep "\[READ\], AverageLatency(us),"`
IFS=',' read -ra ARR <<< "$tmp"
ReadLatency=${ARR[2]}

echo $UpdateCount", "$UpdateLatency", "$ReadCount", "$ReadLatency >> $Output
