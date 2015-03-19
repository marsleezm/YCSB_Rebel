#!/bin/bash

echo cleaning nodes

Nodes=$(cat scripts/allnodes)
./scripts/stopNodes.sh "$Nodes"
