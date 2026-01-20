#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

COUNT=${1:-10}
DENSITY=${2:-50}

mkdir -p "$TESTS_DIR/in/bipartite"

if [ ! -f "$BIN_DIR/test-gen-bipartite" ]; then
    echo "Error: test-gen-bipartite not found. Run 'make' first."
    exit 1
fi

for i in $(seq 1 $COUNT); do
    "$BIN_DIR/test-gen-bipartite" $DENSITY > "$TESTS_DIR/in/bipartite/$i.in"
done
