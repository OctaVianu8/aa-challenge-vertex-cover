#!/bin/bash

# Usage: ./generate-tests-random.sh N
# Generates N random test cases and saves them to ./in/random/

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    echo "  N = number of tests to generate"
    exit 1
fi

N=$1

# Create output directory
mkdir -p ./in/random

# Compile the test generator if needed
if [ ! -f ./test-gen-random ] || [ ./test-gen-random.cpp -nt ./test-gen-random ]; then
    echo "Compiling test generator..."
    g++ -o test-gen-random test-gen-random.cpp
fi

# Generate N tests
for ((i = 1; i <= N; i++)); do
    ./test-gen-random > "./in/random/${i}.in"
    echo "Generated test $i"
done

echo "Done! Generated $N tests in ./in/random/"