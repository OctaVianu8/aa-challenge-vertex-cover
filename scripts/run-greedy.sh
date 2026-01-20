#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

if [ -z "$1" ]; then
    echo "Usage: $0 ALGORITHM"
    echo "  ALGORITHM = name of the greedy algorithm executable (e.g., greedy-highest-order, greedy-remove-edges)"
    exit 1
fi

ALGORITHM=$1

if [ ! -f "$BIN_DIR/$ALGORITHM" ]; then
    echo "Error: $ALGORITHM not found. Run 'make' first."
    exit 1
fi

start_time=$(date +%s.%N)

find "$TESTS_DIR/in" -type f | while read -r input_file; do
    rel_path="${input_file#$TESTS_DIR/in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "$TESTS_DIR/out/$ALGORITHM/$dir_part"

    output_file="$TESTS_DIR/out/$ALGORITHM/$dir_part/${filename_noext}.out"

    "$BIN_DIR/$ALGORITHM" < "$input_file" > "$output_file"
done

end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "$elapsed" > "$TESTS_DIR/out/$ALGORITHM/.time"

echo "Done! Outputs generated in $TESTS_DIR/out/$ALGORITHM/"
