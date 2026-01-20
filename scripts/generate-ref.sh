#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

if [ ! -f "$BIN_DIR/brute-force" ]; then
    echo "Error: brute-force not found. Run 'make' first."
    exit 1
fi

start_time=$(date +%s.%N)

find "$TESTS_DIR/in" -type f | while read -r input_file; do
    rel_path="${input_file#$TESTS_DIR/in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "$TESTS_DIR/ref/$dir_part"

    output_file="$TESTS_DIR/ref/$dir_part/${filename_noext}.ref"

    "$BIN_DIR/brute-force" < "$input_file" > "$output_file"
done

end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "$elapsed" > "$TESTS_DIR/ref/.time"
