import java.io.*;
import java.util.*;

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int x) {
        val = x;
        left = null;
        right = null;
    }
}

public class Arrange {

    public static TreeNode buildTree(Scanner sc) {
        if (!sc.hasNextInt()) return null;
        int num = sc.nextInt();
        if (num == 0) return null;
        TreeNode node = new TreeNode(num);
        node.left = buildTree(sc);
        node.right = buildTree(sc);
        return node;
    }

    public static void getMinInOrder(TreeNode node, List<Integer> result) {
        if (node == null) return;

        List<Integer> leftSequence = new ArrayList<>();
        List<Integer> rightSequence = new ArrayList<>();
        List<Integer> swappedLeft = new ArrayList<>();
        List<Integer> swappedRight = new ArrayList<>();

        getMinInOrder(node.left, leftSequence);
        getMinInOrder(node.right, rightSequence);

        List<Integer> normalOrder = new ArrayList<>(leftSequence);
        normalOrder.add(node.val);
        normalOrder.addAll(rightSequence);

        List<Integer> swappedOrder = new ArrayList<>(rightSequence);
        swappedOrder.add(node.val);
        swappedOrder.addAll(leftSequence);

        if (compareLexicographically(swappedOrder, normalOrder) < 0) {
            result.addAll(swappedOrder);
        } else {
            result.addAll(normalOrder);
        }
    }

    public static int compareLexicographically(List<Integer> list1, List<Integer> list2) {
        int size = Math.min(list1.size(), list2.size());
        for (int i = 0; i < size; i++) {
            if (!list1.get(i).equals(list2.get(i))) {
                return list1.get(i) - list2.get(i);
            }
        }
        return list1.size() - list2.size();
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java Arrange <filename>");
            return;
        }

        String filename = args[0];
        try (Scanner sc = new Scanner(new File(filename))) {
            if (!sc.hasNextLine()) return;
            sc.nextLine(); // Skip the first line
            if (!sc.hasNextLine()) return;
            String line = sc.nextLine();
            Scanner lineScanner = new Scanner(line);

            TreeNode root = buildTree(lineScanner);
            List<Integer> result = new ArrayList<>();
            getMinInOrder(root, result);

            for (int i = 0; i < result.size(); i++) {
                System.out.print(result.get(i));
                if (i != result.size() - 1) System.out.print(" ");
            }
            System.out.println();

        } catch (FileNotFoundException e) {
            System.err.println("Failed to open file: " + filename);
        }
    }
}