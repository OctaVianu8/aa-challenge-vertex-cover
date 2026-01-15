#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    cin >> n >> m;

    vector<vector<int>> adj(n);
    vector<pair<int, int>> edges(m);

    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        edges[i] = {u, v};
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    int startNode = 0;
    int maxDegree = adj[0].size();
    for (int i = 1; i < n; i++) {
        if ((int)adj[i].size() > maxDegree) {
            maxDegree = adj[i].size();
            startNode = i;
        }
    }

    vector<bool> chosen(n, false);
    vector<bool> edgeCovered(m, false);
    vector<bool> visited(n, false);

    queue<int> q;
    q.push(startNode);
    visited[startNode] = true;

    while (!q.empty()) {
        int u = q.front();
        q.pop();

        for (int i = 0; i < m; i++) {
            int eu = edges[i].first;
            int ev = edges[i].second;

            if ((eu == u || ev == u) && !edgeCovered[i]) {
                int v = (eu == u) ? ev : eu;

                if (!chosen[u] && !chosen[v]) {
                    chosen[v] = true;
                }
                edgeCovered[i] = true;
            }
        }

        for (int v : adj[u]) {
            if (!visited[v]) {
                visited[v] = true;
                q.push(v);
            }
        }
    }

    for (int i = 0; i < m; i++) {
        if (!edgeCovered[i]) {
            int u = edges[i].first;
            int v = edges[i].second;
            if (!chosen[u] && !chosen[v]) {
                if (adj[u].size() >= adj[v].size()) {
                    chosen[u] = true;
                } else {
                    chosen[v] = true;
                }
            }
            edgeCovered[i] = true;
        }
    }

    int count = 0;
    for (int i = 0; i < n; i++) {
        if (chosen[i]) {
            count++;
        }
    }
    cout << count << '\n';
    return 0;
}
