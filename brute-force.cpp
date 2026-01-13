#include <iostream>
#include <vector>
#include <climits>

using namespace std;

int n, m;
vector<pair<int, int>> edges;

bool isVertexCover(int mask) {
    for (const auto& e : edges) {
        if (!(mask & (1 << e.first)) && !(mask & (1 << e.second))) {
            return false;
        }
    }
    return true;
}

int countBits(int mask) {
    int count = 0;
    while (mask) {
        count += mask & 1;
        mask >>= 1;
    }
    return count;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    cin >> n >> m;

    edges.resize(m);
    for (int i = 0; i < m; i++) {
        cin >> edges[i].first >> edges[i].second;
    }

    int minCoverSize = INT_MAX;
    int minCoverMask = 0;

    for (int mask = 0; mask < (1 << n); mask++) {
        if (isVertexCover(mask)) {
            int size = countBits(mask);
            if (size < minCoverSize) {
                minCoverSize = size;
                minCoverMask = mask;
            }
        }
    }

	cout << minCoverSize << '\n';
    // cout << "Minimum vertex cover size: " << minCoverSize << "\n";
    // cout << "Vertices in cover: ";
    // for (int i = 0; i < n; i++) {
    //     if (minCoverMask & (1 << i)) {
    //         cout << i << " ";
    //     }
    // }
    // cout << "\n";

    return 0;
}
