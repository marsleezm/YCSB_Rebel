#!/bin/bash

for i in {1..9}
do
	scp -i /home/marco/.ssh/rebel /home/marco/.ssh/rebel*  marco@192.168.1.10${i}:~/.ssh/	
done
