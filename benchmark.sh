#!/bin/bash

# Benchmark script - measures ops/s for different node counts

RUNS_PER_N=50
MAX_N=35
DENSITY=30

echo "Building..."
make brute-force greedy-highest-order greedy-remove-edges test-gen-random > /dev/null 2>&1

# Create benchmark directory
mkdir -p benchmark-graphs

# Function to benchmark an algorithm
benchmark_algo() {
    ALGO=$1
    OUTPUT_FILE="benchmark-graphs/${ALGO}.dat"

    echo "Benchmarking $ALGO..."
    echo "# N avg_ops_per_sec min_ops max_ops" > $OUTPUT_FILE

    for N in $(seq 5 $MAX_N); do
        times=()

        for run in $(seq 1 $RUNS_PER_N); do
            # Generate a test with N nodes
            ./test-gen-random $DENSITY $N > /tmp/bench_test.in 2>/dev/null

            # Time the algorithm (in milliseconds)
            start=$(date +%s%N)
            ./$ALGO < /tmp/bench_test.in > /dev/null 2>&1
            end=$(date +%s%N)

            elapsed_ns=$((end - start))
            if [ $elapsed_ns -gt 0 ]; then
                times+=($elapsed_ns)
            fi
        done

        # Calculate statistics
        if [ ${#times[@]} -gt 0 ]; then
            # Calculate average
            sum=0
            min=${times[0]}
            max=${times[0]}
            for t in "${times[@]}"; do
                sum=$((sum + t))
                if [ $t -lt $min ]; then min=$t; fi
                if [ $t -gt $max ]; then max=$t; fi
            done
            avg=$((sum / ${#times[@]}))

            # Convert to ops/s (1e9 ns per second)
            if [ $avg -gt 0 ]; then
                avg_ops=$(echo "scale=2; 1000000000 / $avg" | bc)
                min_ops=$(echo "scale=2; 1000000000 / $max" | bc)  # min time = max ops
                max_ops=$(echo "scale=2; 1000000000 / $min" | bc)  # max time = min ops
                echo "$N $avg_ops $min_ops $max_ops" >> $OUTPUT_FILE
                echo "  N=$N: avg=${avg_ops} ops/s"
            fi
        fi
    done
}

# Benchmark each algorithm
benchmark_algo "greedy-highest-order"
benchmark_algo "greedy-remove-edges"
benchmark_algo "brute-force"

echo "Done! Data saved to benchmark-graphs/"
echo "Run 'python3 plot-benchmark.py' to generate graphs"
