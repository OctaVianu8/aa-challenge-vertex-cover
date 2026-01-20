#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>
#include <vector>
#include <iomanip>
#include <cmath>

namespace fs = std::filesystem;

using namespace std;

struct TestResult {
    string testName;
    int predicted;
    int reference;
    double accuracy;
};

double calculateAccuracy(int predicted, int reference) {
    if (reference == 0) {
        return (predicted == 0) ? 100.0 : 0.0;
    }

    // For vertex cover, lower is better
    // If predicted == reference, accuracy is 100%
    // If predicted > reference, accuracy decreases based on how far off we are
    // Formula: (reference / predicted) * 100
    // This gives 100% when equal, and decreases as predicted increases

    if (predicted <= reference) {
        return 100.0;  // Perfect or better than reference (shouldn't happen if ref is optimal)
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

int main(int argc, char* argv[]) {
    string algorithm = "greedy-highest-order";
    string refDir = "./ref";

    // Usage: ./calculate-accuracy [ALGORITHM] [REF_DIR]
    if (argc >= 2) {
        algorithm = argv[1];
    }
    if (argc >= 3) {
        refDir = argv[2];
    }

    string outDir = "./out/" + algorithm;

    vector<TestResult> results;
    double totalAccuracy = 0.0;
    int totalTests = 0;
    int perfectMatches = 0;
    int totalPredicted = 0;
    int totalReference = 0;

    for (const auto& entry : fs::recursive_directory_iterator(outDir)) {
        if (!entry.is_regular_file()) continue;

        string filename = entry.path().filename().string();
        string baseName = filename.substr(0, filename.find_last_of('.'));

        // Get relative path from outDir to preserve folder structure
        string relPath = fs::relative(entry.path(), outDir).string();
        string relDir = fs::path(relPath).parent_path().string();

        string outFile = entry.path().string();
        string refFile;
        if (relDir.empty()) {
            refFile = refDir + "/" + baseName + ".ref";
        } else {
            refFile = refDir + "/" + relDir + "/" + baseName + ".ref";
        }

        if (!fs::exists(refFile)) {
            cerr << "Warning: Reference file not found for " << baseName << "\n";
            continue;
        }

        try {
            int predicted = readSingleInt(outFile);
            int reference = readSingleInt(refFile);
            double accuracy = calculateAccuracy(predicted, reference);

            results.push_back({baseName, predicted, reference, accuracy});

            totalAccuracy += accuracy;
            totalTests++;
            totalPredicted += predicted;
            totalReference += reference;

            if (predicted == reference) {
                perfectMatches++;
            }

        } catch (const exception& e) {
            cerr << "Error processing " << baseName << ": " << e.what() << "\n";
        }
    }

    if (totalTests == 0) {
        cerr << "No tests were processed!\n";
        return 1;
    }

    // Summary statistics
    double avgAccuracy = totalAccuracy / totalTests;

    cout << "[" << algorithm << "] ";
    cout << "Tests: " << totalTests << " | ";
    cout << "Perfect: " << perfectMatches << " (" << fixed << setprecision(1) << (100.0 * perfectMatches / totalTests) << "%) | ";
    cout << "Avg accuracy: " << fixed << setprecision(2) << avgAccuracy << "% | ";
    cout << "Excess: +" << (totalPredicted - totalReference) << "\n";

    return 0;
}
