#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    echo "  N = number of cycle-with-cords tests to generate"
    exit 1
fi

N=$1

mkdir -p ./in/cycle-with-cords

if [ ! -f ./test-gen-cycle-with-cords ]; then
    echo "Error: test-gen-cycle-with-cords not found. Run 'make test-gen-cycle-with-cords' first."
    exit 1
fi

for ((i = 1; i <= N; i++)); do
    ./test-gen-cycle-with-cords > "./in/cycle-with-cords/${i}.in"
done
