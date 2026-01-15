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
    string outDir = "./out/greedy-highest-order";
    string refDir = "./ref/random";

    // Allow custom directories via command line
    if (argc >= 3) {
        outDir = argv[1];
        refDir = argv[2];
    }

    vector<TestResult> results;
    double totalAccuracy = 0.0;
    int totalTests = 0;
    int perfectMatches = 0;
    int totalPredicted = 0;
    int totalReference = 0;

    cout << "========================================\n";
    cout << "  Vertex Cover Accuracy Calculator\n";
    cout << "========================================\n\n";
    cout << "Output dir: " << outDir << "\n";
    cout << "Reference dir: " << refDir << "\n\n";

    cout << left << setw(12) << "Test"
         << right << setw(10) << "Predicted"
         << setw(10) << "Reference"
         << setw(12) << "Accuracy"
         << setw(10) << "Diff" << "\n";
    cout << string(54, '-') << "\n";

    for (const auto& entry : fs::directory_iterator(outDir)) {
        if (!entry.is_regular_file()) continue;

        string filename = entry.path().filename().string();
        string baseName = filename.substr(0, filename.find_last_of('.'));

        string outFile = entry.path().string();
        string refFile = refDir + "/" + baseName + ".ref";

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

            int diff = predicted - reference;
            cout << left << setw(12) << baseName
                 << right << setw(10) << predicted
                 << setw(10) << reference
                 << setw(11) << fixed << setprecision(2) << accuracy << "%"
                 << setw(10) << (diff >= 0 ? "+" : "") << diff << "\n";

        } catch (const exception& e) {
            cerr << "Error processing " << baseName << ": " << e.what() << "\n";
        }
    }

    if (totalTests == 0) {
        cerr << "No tests were processed!\n";
        return 1;
    }

    cout << string(54, '-') << "\n\n";

    // Summary statistics
    double avgAccuracy = totalAccuracy / totalTests;
    double overallRatio = (totalPredicted > 0) ?
        (static_cast<double>(totalReference) / totalPredicted) * 100.0 : 0.0;

    cout << "========================================\n";
    cout << "             SUMMARY\n";
    cout << "========================================\n";
    cout << "Total tests:        " << totalTests << "\n";
    cout << "Perfect matches:    " << perfectMatches << " ("
         << fixed << setprecision(1) << (100.0 * perfectMatches / totalTests) << "%)\n";
    cout << "Average accuracy:   " << fixed << setprecision(2) << avgAccuracy << "%\n";
    cout << "Total predicted:    " << totalPredicted << "\n";
    cout << "Total reference:    " << totalReference << "\n";
    cout << "Overall ratio:      " << fixed << setprecision(2) << overallRatio << "%\n";
    cout << "Total excess nodes: " << (totalPredicted - totalReference) << "\n";

    return 0;
}
