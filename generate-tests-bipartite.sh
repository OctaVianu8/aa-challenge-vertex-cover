#!/bin/bash

COUNT=${1:-10}
DENSITY=${2:-50}

mkdir -p in/bipartite

for i in $(seq 1 $COUNT); do
    ./test-gen-bipartite $DENSITY > in/bipartite/$i.in
done
