#!/bin/bash

if [ ! -f ./greedy-highest-order ]; then
    echo "Error: greedy-highest-order not found. Run 'make greedy-highest-order' first."
    exit 1
fi

find ./in -type f | while read -r input_file; do
    rel_path="${input_file#./in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "./out/greedy-highest-order/$dir_part"

    output_file="./out/greedy-highest-order/$dir_part/${filename_noext}.out"

    echo "Processing: $input_file -> $output_file"
    ./greedy-highest-order < "$input_file" > "$output_file"
done

echo "Done! Outputs generated in ./out/greedy-highest-order/"
