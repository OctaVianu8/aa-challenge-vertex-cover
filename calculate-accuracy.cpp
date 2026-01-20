#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>
#include <vector>
#include <map>
#include <iomanip>
#include <cmath>

namespace fs = std::filesystem;

using namespace std;

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

    map<string, ClassStats> classStats;
    ClassStats overall;

    for (const auto& entry : fs::recursive_directory_iterator(outDir)) {
        if (!entry.is_regular_file()) continue;

        string filename = entry.path().filename().string();

        if (filename[0] == '.') continue;

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

        if (!fs::exists(refFile)) {
            continue;
        }

        try {
            int predicted = readSingleInt(outFile);
            int reference = readSingleInt(refFile);
            double accuracy = calculateAccuracy(predicted, reference);

            string className = relDir.empty() ? "default" : relDir;

            classStats[className].totalTests++;
            classStats[className].totalAccuracy += accuracy;
            classStats[className].totalPredicted += predicted;
            classStats[className].totalReference += reference;
            if (predicted == reference) {
                classStats[className].perfectMatches++;
            }

            overall.totalTests++;
            overall.totalAccuracy += accuracy;
            overall.totalPredicted += predicted;
            overall.totalReference += reference;
            if (predicted == reference) {
                overall.perfectMatches++;
            }

        } catch (const exception& e) {
            cerr << "Error processing " << baseName << ": " << e.what() << "\n";
        }
    }

    if (overall.totalTests == 0) {
        cerr << "No tests were processed!\n";
        return 1;
    }

    // Read execution time if available
    string timeFile = outDir + "/.time";
    string execTime = "N/A";
    if (fs::exists(timeFile)) {
        ifstream tf(timeFile);
        if (tf.is_open()) {
            tf >> execTime;
            execTime += "s";
        }
    }

    // per-class statistics
    cout << "[" << algorithm << "] (Time: " << execTime << ")\n";
    for (const auto& [className, stats] : classStats) {
        double avgAccuracy = stats.totalAccuracy / stats.totalTests;
        cout << "  Class " << setw(3) << className << ": ";
        cout << "Tests: " << setw(3) << stats.totalTests << " | ";
        cout << "Perfect: " << setw(3) << stats.perfectMatches << " (" << fixed << setprecision(1) << setw(5) << (100.0 * stats.perfectMatches / stats.totalTests) << "%) | ";
        cout << "Avg: " << fixed << setprecision(2) << setw(6) << avgAccuracy << "% | ";
        cout << "Excess: +" << (stats.totalPredicted - stats.totalReference) << "\n";
    }

    // overall statistics
    double avgAccuracy = overall.totalAccuracy / overall.totalTests;
    cout << "  TOTAL  : ";
    cout << "Tests: " << setw(3) << overall.totalTests << " | ";
    cout << "Perfect: " << setw(3) << overall.perfectMatches << " (" << fixed << setprecision(1) << setw(5) << (100.0 * overall.perfectMatches / overall.totalTests) << "%) | ";
    cout << "Avg: " << fixed << setprecision(2) << setw(6) << avgAccuracy << "% | ";
    cout << "Excess: +" << (overall.totalPredicted - overall.totalReference) << "\n";

    return 0;
}
