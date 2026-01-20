#!/bin/bash

# Get project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$PROJECT_ROOT/bin"
TESTS_DIR="$PROJECT_ROOT/tests"

if [ ! -f "$BIN_DIR/greedy-highest-order" ]; then
    echo "Error: greedy-highest-order not found. Run 'make' first."
    exit 1
fi

find "$TESTS_DIR/in" -type f | while read -r input_file; do
    rel_path="${input_file#$TESTS_DIR/in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "$TESTS_DIR/out/greedy-highest-order/$dir_part"

    output_file="$TESTS_DIR/out/greedy-highest-order/$dir_part/${filename_noext}.out"

    echo "Processing: $input_file -> $output_file"
    "$BIN_DIR/greedy-highest-order" < "$input_file" > "$output_file"
done

echo "Done! Outputs generated in $TESTS_DIR/out/greedy-highest-order/"
