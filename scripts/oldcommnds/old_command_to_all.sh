#!/bin/bash

for ip in $(cat ip_list)
do
	ssh -i key ubuntu@$ip "ifconfig | grep Bcast | awk '{print $2}' | awk -F":" '{print $2}'"
done
