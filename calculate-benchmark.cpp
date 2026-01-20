
#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>
#include <vector>
#include <map>
#include <iomanip>
#include <cmath>
#include <string>
#ifdef USE_BENCHMARK
#include <benchmark/benchmark.h>
#endif

using namespace std;
namespace fs = std::filesystem;

double calculateAccuracy(int predicted, int reference);
int readSingleInt(const string& filepath);

#ifdef USE_BENCHMARK
static void BM_CalculateAccuracyImpl(benchmark::State& state, const string& algorithm) {
    string refDir = "./ref";
    string outDir = "./out/" + algorithm;
    for (auto _ : state) {
        int count = 0;
        for (const auto& entry : fs::recursive_directory_iterator(outDir)) {
            if (!entry.is_regular_file()) continue;
            string filename = entry.path().filename().string();
            string baseName = filename.substr(0, filename.find_last_of('.'));
            string relPath = fs::relative(entry.path(), outDir).string();
            string relDir = fs::path(relPath).parent_path().string();
            string outFile = entry.path().string();
            string refFile;
            if (relDir.empty()) {
                refFile = refDir + "/" + baseName + ".ref";
            } else {
                refFile = refDir + "/" + relDir + "/" + baseName + ".ref";
            }
            if (!fs::exists(refFile)) continue;
            int predicted = readSingleInt(outFile);
            int reference = readSingleInt(refFile);
            benchmark::DoNotOptimize(calculateAccuracy(predicted, reference));
            ++count;
        }
        benchmark::ClobberMemory();
    }
}

static void BM_CalculateAccuracy_GreedyHighestOrder(benchmark::State& state) {
    BM_CalculateAccuracyImpl(state, "greedy-highest-order");
}
BENCHMARK(BM_CalculateAccuracy_GreedyHighestOrder);

static void BM_CalculateAccuracy_GreedyRemoveEdges(benchmark::State& state) {
    BM_CalculateAccuracyImpl(state, "greedy-remove-edges");
}
BENCHMARK(BM_CalculateAccuracy_GreedyRemoveEdges);
#endif

struct ClassStats {
    int totalTests = 0;
    int perfectMatches = 0;
    double totalAccuracy = 0.0;
    int totalPredicted = 0;
    int totalReference = 0;
};

double calculateAccuracy(int predicted, int reference) {
    if (reference == 0) {
        return (predicted == 0) ? 100.0 : 0.0;
    }

    if (predicted <= reference) {
        return 100.0;
    }

    return (static_cast<double>(reference) / predicted) * 100.0;
}

int readSingleInt(const string& filepath) {
    ifstream file(filepath);
    if (!file.is_open()) {
        throw runtime_error("Cannot open file: " + filepath);
    }
    int value;
    file >> value;
    return value;
}


#ifndef USE_BENCHMARK
int main(int argc, char* argv[]) {
    return 0;
}
#endif
