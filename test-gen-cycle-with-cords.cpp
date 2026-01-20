#include <iostream>
#include <vector>
#include <set>
#include <random>

using namespace std;

int main(int argc, char* argv[]) {
    const int N = 20;
    set<pair<int, int>> edges;

    random_device rd;
    mt19937 gen(rd());

        // Cycle with some chords
        for (int i = 0; i < N; i++) {
            edges.insert({i, (i + 1) % N});
        }
        // Add some random chords
        uniform_int_distribution<> nodeDist(0, N - 1);
        for (int i = 0; i < 5; i++) {
            int u = nodeDist(gen);
            int v = nodeDist(gen);
            if (u != v && abs(u - v) > 1 && abs(u - v) < N - 1) {
                if (u > v) swap(u, v);
                edges.insert({u, v});
            }
        }

    // Ensure we have at least some edges
    if (edges.size() < 3) {
        edges.insert({0, 1});
        edges.insert({1, 2});
        edges.insert({2, 3});
    }

    cout << N << " " << edges.size() << "\n";
    for (const auto& e : edges) {
        cout << e.first << " " << e.second << "\n";
    }

    return 0;
}

