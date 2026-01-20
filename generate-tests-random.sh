#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 N [DENSITY]"
    echo "  N = number of tests to generate"
    echo "  DENSITY = edge density percentage (1-100), default 15"
    exit 1
fi

N=$1
DENSITY=${2:-15}

mkdir -p ./in/$DENSITY

if [ ! -f ./test-gen-random ]; then
    echo "Error: test-gen-random not found. Run 'make test-gen-random' first."
    exit 1
fi

for ((i = 1; i <= N; i++)); do
    ./test-gen-random "$DENSITY" > "./in/${DENSITY}/${i}.in"
    echo "Generated test $i"
done

echo "Done! Generated $N tests in ./in/${DENSITY}/ with density ${DENSITY}%"