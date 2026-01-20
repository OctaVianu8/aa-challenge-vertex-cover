#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

if [ -z "$1" ]; then
    echo "Usage: $0 N [DENSITY]"
    echo "  N = number of tests to generate"
    echo "  DENSITY = edge density percentage (1-100), default 15"
    exit 1
fi

N=$1
DENSITY=${2:-15}

mkdir -p "$TESTS_DIR/in/$DENSITY"

if [ ! -f "$BIN_DIR/test-gen-random" ]; then
    echo "Error: test-gen-random not found. Run 'make' first."
    exit 1
fi

for ((i = 1; i <= N; i++)); do
    "$BIN_DIR/test-gen-random" "$DENSITY" > "$TESTS_DIR/in/${DENSITY}/${i}.in"
done