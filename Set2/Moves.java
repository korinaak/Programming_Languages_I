import java.io.*;
import java.util.*;

public class Moves {
    static class Point implements Comparable<Point> {
        int x, y, cars;
        Point parent;
        String direction;

        Point(int x, int y, int cars, Point parent, String direction) {
            this.x = x;
            this.y = y;
            this.cars = cars;
            this.parent = parent;
            this.direction = direction;
        }

        @Override
        public int compareTo(Point other) {
            return Integer.compare(this.cars, other.cars);
        }
    }

    private static final int[][] DIRECTIONS = {
            {0, 1, 'E'}, {1, 0, 'S'}, {0, -1, 'W'}, {-1, 0, 'N'},
            {-1, 1, 'N' + 'E'}, {1, 1, 'S' + 'E'}, {-1, -1, 'N' + 'W'}, {1, -1, 'S' + 'W'}
    };

    private static final String[] DIRECTION_STRINGS = {
            "E", "S", "W", "N", "NE", "SE", "NW", "SW"
    };

    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java Moves <input_file>");
            return;
        }

        try {
            BufferedReader br = new BufferedReader(new FileReader(args[0]));
            int N = Integer.parseInt(br.readLine().trim());
            int[][] grid = new int[N][N];
            for (int i = 0; i < N; i++) {
                String[] tokens = br.readLine().trim().split("\\s+");
                for (int j = 0; j < N; j++) {
                    grid[i][j] = Integer.parseInt(tokens[j]);
                }
            }
            br.close();
            String result = findShortestPath(grid, N);
            System.out.println(result);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String findShortestPath(int[][] grid, int N) {
        boolean[][] visited = new boolean[N][N];
        PriorityQueue<Point> queue = new PriorityQueue<>();
        queue.add(new Point(0, 0, grid[0][0], null, " "));

        while (!queue.isEmpty()) {
            Point current = queue.poll();
            int cx = current.x, cy = current.y;

            if (visited[cx][cy]) continue;
            visited[cx][cy] = true;

            if (cx == N - 1 && cy == N - 1) {
                return constructPath(current);
            }

            for (int i = 0; i < DIRECTIONS.length; i++) {
                int nx = cx + DIRECTIONS[i][0];
                int ny = cy + DIRECTIONS[i][1];

                if (nx >= 0 && nx < N && ny >= 0 && ny < N && !visited[nx][ny] && grid[nx][ny] < current.cars) {
                    queue.add(new Point(nx, ny, grid[nx][ny], current, DIRECTION_STRINGS[i]));
                }
            }
        }

        return "IMPOSSIBLE";
    }

    private static String constructPath(Point end) {
        List<String> path = new ArrayList<>();
        for (Point p = end; p.parent != null; p = p.parent) {
            path.add(p.direction);
        }
        Collections.reverse(path);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < path.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(path.get(i));
        }
        sb.append("]");
        return sb.toString();
    }
}