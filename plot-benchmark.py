#!/usr/bin/env python3
"""
Generate benchmark plots for Vertex Cover algorithms.
Similar style to the Graph Coloring report figures.
"""

import matplotlib.pyplot as plt
import numpy as np
import os
import subprocess
import time
import random

# Configuration
MAX_N = 40
RUNS_PER_N = 30
DENSITY = 0.30

def generate_random_graph(n, density):
    """Generate a random graph with n nodes and given edge density."""
    edges = []
    for i in range(n):
        for j in range(i + 1, n):
            if random.random() < density:
                edges.append((i, j))
    return n, edges

def write_graph_to_file(n, edges, filename):
    """Write graph to file in the expected format."""
    with open(filename, 'w') as f:
        f.write(f"{n} {len(edges)}\n")
        for u, v in edges:
            f.write(f"{u} {v}\n")

def benchmark_algorithm(algo_name, max_n=MAX_N, runs=RUNS_PER_N):
    """Benchmark an algorithm across different node counts."""
    results = {}

    for n in range(5, max_n + 1):
        times = []

        for _ in range(runs):
            # Generate random graph
            _, edges = generate_random_graph(n, DENSITY)
            write_graph_to_file(n, edges, '/tmp/bench_test.in')

            # Time the algorithm
            start = time.perf_counter()
            try:
                result = subprocess.run(
                    [f'./{algo_name}'],
                    stdin=open('/tmp/bench_test.in'),
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    timeout=30
                )
                elapsed = time.perf_counter() - start
                times.append(elapsed)
            except subprocess.TimeoutExpired:
                print(f"  {algo_name} timeout at N={n}")
                break

        if times:
            avg_time = np.mean(times)
            std_time = np.std(times)
            min_time = np.min(times)
            max_time = np.max(times)

            # Calculate ops/s
            avg_ops = 1.0 / avg_time if avg_time > 0 else 0
            min_ops = 1.0 / max_time if max_time > 0 else 0
            max_ops = 1.0 / min_time if min_time > 0 else 0

            # 99th percentile (approximate using mean + 2.33*std)
            p99_time = np.percentile(times, 99)
            p99_ops = 1.0 / p99_time if p99_time > 0 else 0

            results[n] = {
                'avg_ops': avg_ops,
                'min_ops': min_ops,
                'max_ops': max_ops,
                'p99_ops': p99_ops,
                'avg_time': avg_time
            }
            print(f"  {algo_name} N={n}: {avg_ops:.0f} ops/s (avg time: {avg_time*1000:.2f}ms)")
        else:
            break

    return results

def plot_algorithm(ax, results, title, color='blue'):
    """Plot results for a single algorithm."""
    ns = sorted(results.keys())
    avg_ops = [results[n]['avg_ops'] for n in ns]
    min_ops = [results[n]['min_ops'] for n in ns]
    max_ops = [results[n]['max_ops'] for n in ns]

    # Plot with error bars (showing range)
    ax.errorbar(ns, avg_ops,
                yerr=[np.array(avg_ops) - np.array(min_ops),
                      np.array(max_ops) - np.array(avg_ops)],
                fmt='-', color=color, capsize=2, capthick=1,
                label='99th percentile, avg ops')

    ax.set_xlabel('node count')
    ax.set_ylabel('ops/s')
    ax.set_title(title)
    ax.legend(loc='upper right')
    ax.grid(True, alpha=0.3)
    ax.set_xlim(0, max(ns) + 5)

def main():
    # Change to project directory
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    print("Benchmarking Vertex Cover algorithms...")
    print("="*50)

    # Benchmark each algorithm
    print("\n[1/3] Benchmarking greedy-highest-order...")
    results_gho = benchmark_algorithm('greedy-highest-order', max_n=50)

    print("\n[2/3] Benchmarking greedy-remove-edges...")
    results_gre = benchmark_algorithm('greedy-remove-edges', max_n=50)

    print("\n[3/3] Benchmarking brute-force (limited to smaller N)...")
    results_bf = benchmark_algorithm('brute-force', max_n=25, runs=10)

    print("\n" + "="*50)
    print("Generating plots...")

    # Create figure with vertical subplots (4 rows, 1 column)
    fig, axes = plt.subplots(4, 1, figsize=(10, 16))

    # Plot each algorithm
    plot_algorithm(axes[0], results_gho,
                   'Fig. 1: Greedy cu BFS, n vs ops/s', 'blue')

    plot_algorithm(axes[1], results_gre,
                   'Fig. 2: Greedy cu grad maxim, n vs ops/s', 'green')

    if results_bf:
        plot_algorithm(axes[2], results_bf,
                       'Fig. 3: Brute-Force, n vs ops/s', 'red')

    # Comparison plot
    ax = axes[3]
    ns_gho = sorted(results_gho.keys())
    ns_gre = sorted(results_gre.keys())
    ns_bf = sorted(results_bf.keys()) if results_bf else []

    ax.plot(ns_gho, [results_gho[n]['avg_ops'] for n in ns_gho],
            '-o', label='Greedy BFS', markersize=3)
    ax.plot(ns_gre, [results_gre[n]['avg_ops'] for n in ns_gre],
            '-s', label='Greedy grad maxim', markersize=3)
    if ns_bf:
        ax.plot(ns_bf, [results_bf[n]['avg_ops'] for n in ns_bf],
                '-^', label='Brute-Force', markersize=3)

    ax.set_xlabel('node count')
    ax.set_ylabel('ops/s')
    ax.set_title('Fig. 4: Comparație algoritmi')
    ax.legend()
    ax.grid(True, alpha=0.3)
    ax.set_yscale('log')

    plt.tight_layout()
    plt.savefig('benchmark/benchmark_plots.png', dpi=150)
    plt.savefig('benchmark/benchmark_plots.pdf')
    print("Saved: benchmark/benchmark_plots.png")
    print("Saved: benchmark/benchmark_plots.pdf")

    # Also create individual plots for the report
    for name, results, title, color in [
        ('greedy-highest-order', results_gho, 'Greedy cu BFS, n vs ops/s', 'blue'),
        ('greedy-remove-edges', results_gre, 'Greedy cu grad maxim, n vs ops/s', 'green'),
        ('brute-force', results_bf, 'Brute-Force, n vs ops/s', 'red')
    ]:
        if results:
            fig, ax = plt.subplots(figsize=(6, 4))
            plot_algorithm(ax, results, title, color)
            plt.tight_layout()
            plt.savefig(f'benchmark/{name}.png', dpi=150)
            plt.savefig(f'benchmark/{name}.pdf')
            print(f"Saved: benchmark/{name}.png")
            plt.close()

if __name__ == '__main__':
    main()
