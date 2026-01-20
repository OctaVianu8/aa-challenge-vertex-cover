#include <iostream>
#include <vector>
#include <random>
#include <set>
#include <ctime>
#include <cstdlib>

using namespace std;

int main(int argc, char* argv[]) {
    const int N = 20;
    double DENSITY = 0.15;
    if (argc > 1) {
        DENSITY = atof(argv[1]) / 100.0;
    }

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
