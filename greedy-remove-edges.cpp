#include <bits/stdc++.h>

using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    cin >> n >> m;

    vector<set<int>> adj(n);

    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].insert(v);
        adj[v].insert(u);
    }

    int counter = 0;
    int remainingEdges = m;

    while (remainingEdges > 0) {
        int maxDegree = -1;
        int bestNode = -1;
        int bestMinNeighDegree = INT_MAX;

        for (int i = 0; i < n; i++) {
            int degree = adj[i].size();
            if (degree == 0) continue;

            int minNeighDegree = INT_MAX;
            for (int neighbor : adj[i]) {
                minNeighDegree = min(minNeighDegree, (int)adj[neighbor].size());
            }

            // Tie-break: the node with a neighbor that has the lowest degree
            if (degree > maxDegree ||
                (degree == maxDegree && minNeighDegree < bestMinNeighDegree)) {
                maxDegree = degree;
                bestNode = i;
                bestMinNeighDegree = minNeighDegree;
            }
        }

        if (bestNode == -1 || maxDegree == 0) break;

        for (int neighbor : adj[bestNode]) {
            adj[neighbor].erase(bestNode);
            remainingEdges--;
        }
        adj[bestNode].clear();

        counter++;
    }

    cout << counter << '\n';

    return 0;
}
