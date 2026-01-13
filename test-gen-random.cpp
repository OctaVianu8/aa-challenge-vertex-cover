#include <iostream>
#include <vector>
#include <random>
#include <set>
#include <ctime>

using namespace std;

int main() {
    const int N = 20;           // number of nodes
    const double DENSITY = 0.15; // edge probability (~15% for sparse graph)

    // Random number generator
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<> dis(0.0, 1.0);

    set<pair<int, int>> edges;

    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j < N; j++) {
            if (dis(gen) < DENSITY) {
                edges.insert({i, j});
            }
        }
    }
    cout << N << " " << edges.size() << "\n";
    for (const auto& e : edges) {
        cout << e.first << " " << e.second << "\n";
    }

    return 0;
}
