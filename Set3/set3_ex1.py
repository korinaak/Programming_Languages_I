import sys
import math

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <filename>")
        return 1

    filename = sys.argv[1]

    try:
        with open(filename, 'r') as file:
            N = int(file.readline().strip())
            numbers = list(map(int, file.readline().strip().split()))
    except FileNotFoundError:
        print("Error: File could not be opened.")
        return 1
    except ValueError:
        print("Error: Incorrect file format.")
        return 1

    totalSum = sum(numbers)
    minDifference = float('inf')
    currentSum = 0

    for i in range(N):
        currentSum = 0
        for j in range(i, N):
            currentSum += numbers[j]
            complementSum = totalSum - currentSum
            currentDifference = abs(currentSum - complementSum)
            if currentDifference < minDifference:
                minDifference = currentDifference

    print(minDifference)
    return 0

if __name__ == "__main__":
    main()