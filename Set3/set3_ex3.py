import heapq

class Point:
    def __init__(self, x, y, cars, parent, direction):
        self.x = x
        self.y = y
        self.cars = cars
        self.parent = parent
        self.direction = direction

    def __lt__(self, other):
        return self.cars < other.cars

DIRECTIONS = [
    (0, 1, "E"), (1, 0, "S"), (0, -1, "W"), (-1, 0, "N"),
    (-1, 1, "NE"), (1, 1, "SE"), (-1, -1, "NW"), (1, -1, "SW")
]

def read_grid(filename):
    with open(filename, 'r') as file:
        N = int(file.readline().strip())
        grid = []
        for _ in range(N):
            row = list(map(int, file.readline().strip().split()))
            grid.append(row)
    return N, grid

def construct_path(end):
    path = []
    while end.parent:
        path.append(end.direction)
        end = end.parent
    return "[" + ",".join(reversed(path)) + "]"

def find_shortest_path(grid, N):
    visited = [[False] * N for _ in range(N)]
    queue = []
    heapq.heappush(queue, Point(0, 0, grid[0][0], None, ""))

    while queue:
        current = heapq.heappop(queue)
        cx, cy = current.x, current.y

        if visited[cx][cy]:
            continue
        visited[cx][cy] = True

        if cx == N - 1 and cy == N - 1:
            return construct_path(current)

        for dx, dy, direction in DIRECTIONS:
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < N and 0 <= ny < N and not visited[nx][ny] and grid[nx][ny] < current.cars:
                heapq.heappush(queue, Point(nx, ny, grid[nx][ny], current, direction))

    return "IMPOSSIBLE"

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python moves.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    N, grid = read_grid(input_file)
    result = find_shortest_path(grid, N)
    print(result)