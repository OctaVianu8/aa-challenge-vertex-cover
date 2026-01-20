#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

if [ -z "$1" ]; then
    echo "Usage: $0 N"
    echo "  N = number of cycle-with-cords tests to generate"
    exit 1
fi

N=$1

mkdir -p "$TESTS_DIR/in/cycle-with-cords"

if [ ! -f "$BIN_DIR/test-gen-cycle-with-cords" ]; then
    echo "Error: test-gen-cycle-with-cords not found. Run 'make' first."
    exit 1
fi

for ((i = 1; i <= N; i++)); do
    "$BIN_DIR/test-gen-cycle-with-cords" > "$TESTS_DIR/in/cycle-with-cords/${i}.in"
done
