#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    echo "  N = number of tests to generate"
    exit 1
fi

N=$1

mkdir -p ./in/random

if [ ! -f ./test-gen-random ]; then
    echo "Error: test-gen-random not found. Run 'make test-gen-random' first."
    exit 1
fi

for ((i = 1; i <= N; i++)); do
    ./test-gen-random > "./in/random/${i}.in"
    echo "Generated test $i"
done

echo "Done! Generated $N tests in ./in/random/"