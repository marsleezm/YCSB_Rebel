#!/bin/bash

./scripts/stopNodes.sh
./scripts/startNodes.sh
./scripts/command_to_all.sh "nodetool repair"
