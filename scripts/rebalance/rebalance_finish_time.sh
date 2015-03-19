#!/bin/bash

/usr/bin/time -f "%e" -o tmp ./scripts/rebalance/rebalance_finished.sh $1 > /dev/null
cat tmp
