#include <iostream>
#include <set>
#include <random>

using namespace std;

int main(int argc, char* argv[]) {
    // Bipartite graph generator
    // Two sets A and B, edges only between A and B

    int density = 50;  // percentage of possible edges
    if (argc > 1) {
        density = atoi(argv[1]);
        if (density < 1) density = 1;
        if (density > 100) density = 100;
    }

    const int N = 20;
    random_device rd;
    mt19937 gen(rd());

    // Split nodes: A = [0, sizeA), B = [sizeA, N)
    int sizeA = N / 2 + (gen() % 3) - 1;  // roughly half, with some variance
    if (sizeA < 2) sizeA = 2;
    if (sizeA > N - 2) sizeA = N - 2;
    int sizeB = N - sizeA;

    set<pair<int, int>> edges;
    uniform_int_distribution<> prob(1, 100);

    // Add edges only between A and B
    for (int a = 0; a < sizeA; a++) {
        for (int b = sizeA; b < N; b++) {
            if (prob(gen) <= density) {
                edges.insert({a, b});
            }
        }
    }

    // Ensure graph is connected (at least one edge per node)
    for (int a = 0; a < sizeA; a++) {
        bool hasEdge = false;
        for (const auto& e : edges) {
            if (e.first == a) { hasEdge = true; break; }
        }
        if (!hasEdge) {
            int b = sizeA + (gen() % sizeB);
            edges.insert({a, b});
        }
    }
    for (int b = sizeA; b < N; b++) {
        bool hasEdge = false;
        for (const auto& e : edges) {
            if (e.second == b) { hasEdge = true; break; }
        }
        if (!hasEdge) {
            int a = gen() % sizeA;
            edges.insert({a, b});
        }
    }

    cout << N << " " << edges.size() << "\n";
    for (const auto& e : edges) {
        cout << e.first << " " << e.second << "\n";
    }

    return 0;
}
