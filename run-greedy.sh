#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 ALGORITHM"
    echo "  ALGORITHM = name of the greedy algorithm executable (e.g., greedy-highest-order, greedy-remove-edges)"
    exit 1
fi

ALGORITHM=$1

if [ ! -f "./$ALGORITHM" ]; then
    echo "Error: $ALGORITHM not found. Run 'make $ALGORITHM' first."
    exit 1
fi

# Measure total execution time
start_time=$(date +%s.%N)

find ./in -type f | while read -r input_file; do
    rel_path="${input_file#./in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "./out/$ALGORITHM/$dir_part"

    output_file="./out/$ALGORITHM/$dir_part/${filename_noext}.out"

    ./$ALGORITHM < "$input_file" > "$output_file"
done

end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "$elapsed" > "./out/$ALGORITHM/.time"

echo "Done! Outputs generated in ./out/$ALGORITHM/"
