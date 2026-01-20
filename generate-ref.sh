#!/bin/bash

if [ ! -f ./brute-force ]; then
    echo "Error: brute-force not found. Run 'make brute-force' first."
    exit 1
fi

# Measure total execution time
start_time=$(date +%s.%N)

find ./in -type f | while read -r input_file; do
    rel_path="${input_file#./in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "./ref/$dir_part"

    output_file="./ref/$dir_part/${filename_noext}.ref"

    ./brute-force < "$input_file" > "$output_file"
done

end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "$elapsed" > "./ref/.time"
