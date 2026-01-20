# AA Challenge Vertex Cover

Benchmarks greedy heuristics for the Minimum Vertex Cover problem against brute-force optimal solutions.

## Algorithms

| Algorithm | Complexity | Accuracy |
|-----------|------------|----------|
| **brute-force** | O(2ⁿ · \|E\|) | 100% (optimal) |
| **greedy-highest-order** | O(\|V\| · \|E\|) | 46.4% perfect, 94.1% avg |
| **greedy-remove-edges** | O(\|V\| · \|E\|) | 84.4% perfect, 98.6% avg |

## Usage

```bash
make pipeline      # Run full pipeline: generate tests, compute refs, run heuristics, calculate accuracy
make benchmark     # Generate performance graphs (ops/s vs N)
make clean         # Remove generated files
```

## Project Structure

- `brute-force.cpp` — Exact solution via bitmask enumeration
- `greedy-highest-order.cpp` — BFS-based greedy heuristic
- `greedy-remove-edges.cpp` — Greedy with min-neighbor-degree tie-breaking
- `test-gen-*.cpp` — Test generators (random, bipartite, cycle-with-cords)
- `calculate-accuracy.cpp` — Compare outputs with optimal references
- `report.tex` — Full documentation with proofs and analysis

## Test Classes

500 tests total (100 per class): random graphs at 10%/30%/67% density, bipartite graphs, and cycles with random chords. All graphs have N ≤ 20 nodes for tractable brute-force computation.