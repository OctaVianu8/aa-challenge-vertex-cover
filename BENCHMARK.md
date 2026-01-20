# Benchmark - calculate-accuracy

Masoara performanta prelucrarii fisierelor pentru ambii algoritmi greedy.

## Compilare

```bash
make calculate-benchmark
```

## Rulare

```bash
./calculate-benchmark
```

## Optiuni

```bash
# Doar greedy-highest-order
./calculate-benchmark --benchmark_filter=GreedyHighestOrder

# Doar greedy-remove-edges
./calculate-benchmark --benchmark_filter=GreedyRemoveEdges

# 10 repetari
./calculate-benchmark --benchmark_repetitions=10

# Export JSON
./calculate-benchmark --benchmark_format=json > results.json

# Toate optiunile
./calculate-benchmark --help
```

## Setup Google Benchmark

```bash
# Clone Google Benchmark
git clone https://github.com/google/benchmark.git

# Build
cd benchmark
cmake -E make_directory build
cmake -E chdir build cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=on -DCMAKE_BUILD_TYPE=Release ..
cmake --build build --config Release
cd ..
```
