#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <climits>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <filename>" << std::endl;
        return 1;
    }

    std::ifstream file(argv[1]);
    if (!file.is_open()) {
        std::cerr << "Error: File could not be opened." << std::endl;
        return 1;
    }

    int N;
    file >> N;

    std::vector<int> numbers(N);
    long long totalSum = 0;

    for (int i = 0; i < N; ++i) {
        file >> numbers[i];
        totalSum += numbers[i];
    }

    file.close();

    long long minDifference = LLONG_MAX;
    long long currentSum = 0;

    for (int i = 0; i < N; ++i) {
        currentSum = 0;
        for (int j = i; j < N; ++j) {
            currentSum += numbers[j];
            long long complementSum = totalSum - currentSum;
            long long currentDifference = std::abs(currentSum - complementSum);
            if (currentDifference < minDifference) {
                minDifference = currentDifference;
            }
        }
    }

    std::cout << minDifference << std::endl;
    return 0;
}