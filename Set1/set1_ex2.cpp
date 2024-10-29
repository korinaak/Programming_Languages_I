#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <fstream>
#include <climits>
#include <algorithm>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

TreeNode* buildTree(istringstream &iss) {
    int num;
    iss >> num;
    if (num == 0) return nullptr;

    TreeNode* node = new TreeNode(num);
    node->left = buildTree(iss);
    node->right = buildTree(iss);
    return node;
}

void getMinInOrder(TreeNode* node, vector<int>& result) {
    if (!node) return;

    vector<int> leftSequence, rightSequence, swappedLeft, swappedRight;
    getMinInOrder(node->left, leftSequence);
    getMinInOrder(node->right, rightSequence);

    vector<int> normalOrder(leftSequence);
    normalOrder.push_back(node->val);
    normalOrder.insert(normalOrder.end(), rightSequence.begin(), rightSequence.end());

    vector<int> swappedOrder(rightSequence);
    swappedOrder.push_back(node->val);
    swappedOrder.insert(swappedOrder.end(), leftSequence.begin(), leftSequence.end());

    if (lexicographical_compare(swappedOrder.begin(), swappedOrder.end(), normalOrder.begin(), normalOrder.end())) {
        result.swap(swappedOrder);
    } else {
        result.swap(normalOrder);
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        cerr << "Usage: " << argv[0] << " <filename>" << endl;
        return 1;
    }

    ifstream file(argv[1]);
    if (!file.is_open()) {
        cerr << "Failed to open file: " << argv[1] << endl;
        return 1;
    }

    string line;
    getline(file, line);  
    getline(file, line); 
    istringstream iss(line);

    TreeNode* root = buildTree(iss);
    vector<int> result;
    getMinInOrder(root, result);

    for (size_t i = 0; i < result.size(); ++i) {
        cout << result[i];
        if (i != result.size() - 1) cout << " ";
    }
    cout << endl;

    return 0;
}