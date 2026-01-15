#!/bin/bash

if [ ! -f ./brute-force ]; then
    echo "Error: brute-force not found. Run 'make brute-force' first."
    exit 1
fi

find ./in -type f | while read -r input_file; do
    rel_path="${input_file#./in/}"

    dir_part=$(dirname "$rel_path")

    filename=$(basename "$rel_path")
    filename_noext="${filename%.*}"

    mkdir -p "./ref/$dir_part"

    output_file="./ref/$dir_part/${filename_noext}.ref"

    echo "Processing: $input_file -> $output_file"
    ./brute-force < "$input_file" > "$output_file"
done

echo "Done! Reference outputs generated in ./ref/"
