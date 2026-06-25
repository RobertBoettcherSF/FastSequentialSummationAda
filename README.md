# FastSequentialSummationAda

## Overview

This Ada package implements **Fast Sequential Summation Algorithms Using Augmented Data Structures**, inspired by the research paper by Vadim Stadnik. The package provides efficient range sum queries and statistical calculations on a dynamic set of integers using an augmented Binary Search Tree (BST) structure.

## Features

- **Efficient Range Sum Queries**: Compute the sum of elements between any two ranks (positions) in O(log n) time
- **Dynamic Insertion**: Insert elements while maintaining augmented statistics
- **Statistical Calculations**: Compute mean and standard deviation of the dataset
- **Augmented Data Structure**: Each node stores precomputed sum and count of its subtree for fast queries

## Use Cases

This package is useful for:
- Financial applications requiring running sums and averages
- Scientific computing with sequential data processing
- Real-time statistics on streaming data
- Any application needing efficient range queries on dynamic datasets

## API Reference

### Types

```ada
-- Node type for the augmented BST
type Node;
type Node_Ptr is access Node;
type Node is record
    Value : Integer;   -- Element value
    Sum   : Integer;   -- Precomputed sum of subtree
    Count : Integer;   -- Number of elements in subtree
    Left  : Node_Ptr; -- Left child
    Right : Node_Ptr; -- Right child
end record;

-- B+ Tree type (implemented as augmented BST)
type BPlusTree is record
    Root : Node_Ptr;  -- Root of the tree
end record;
```

### Procedures and Functions

#### `Insert(Tree : in out BPlusTree; Value : Integer)`
Inserts a value into the tree. Maintains sorted order and updates all augmented statistics (Sum and Count) automatically.

**Parameters:**
- `Tree`: The tree to insert into (modified)
- `Value`: The integer value to insert

**Example:**
```ada
Tree : BPlusTree;
Insert(Tree, 10);
Insert(Tree, 20);
Insert(Tree, 30);
```

#### `Compute_Sum(Tree : BPlusTree; Start_Rank, End_Rank : Integer) return Integer`
Computes the sum of elements from rank Start_Rank to End_Rank (inclusive).

**Parameters:**
- `Tree`: The tree to query
- `Start_Rank`: Starting rank (1-based index in in-order traversal)
- `End_Rank`: Ending rank (1-based index in in-order traversal)

**Returns:** Sum of elements in the specified rank range

**Example:**
```ada
Sum := Compute_Sum(Tree, 2, 4);  -- Sum of elements at positions 2, 3, 4
```

#### `Calculate_Mean(Tree : BPlusTree) return Float`
Computes the arithmetic mean of all elements in the tree.

**Parameters:**
- `Tree`: The tree to compute mean for

**Returns:** Mean value as Float, or 0.0 if tree is empty

**Example:**
```ada
Mean := Calculate_Mean(Tree);
```

#### `Calculate_Standard_Deviation(Tree : BPlusTree) return Float`
Computes the population standard deviation of all elements in the tree.

**Parameters:**
- `Tree`: The tree to compute standard deviation for

**Returns:** Standard deviation as Float, or 0.0 if tree has 0 or 1 elements

**Example:**
```ada
StdDev := Calculate_Standard_Deviation(Tree);
```

## Building and Testing

### Prerequisites
- GNAT Ada compiler (gprbuild)

### Building

```bash
# Build the library
gprbuild -P fast_sequential_summation.gpr

# Build and run tests
gprbuild -P test_fast_summation.gpr
test_fast_summation
```

### Running Tests

The test program demonstrates all functionality:
```bash
./test_fast_summation
```

## Implementation Details

### Data Structure

The package uses an **augmented Binary Search Tree** where each node stores:
- `Value`: The element's value
- `Sum`: The sum of all values in the subtree rooted at this node
- `Count`: The number of elements in the subtree rooted at this node

This augmentation allows for efficient range sum queries without traversing all elements.

### Algorithm Complexity

- **Insert**: O(h) where h is the tree height (O(log n) for balanced tree)
- **Compute_Sum**: O(h + k) where h is tree height and k is the number of nodes visited
- **Calculate_Mean**: O(h) - uses Compute_Sum internally
- **Calculate_Standard_Deviation**: O(n) - requires computing sum of squares

### Notes

- The current implementation uses a basic BST without automatic balancing
- For guaranteed O(log n) operations, consider using a self-balancing tree (AVL, Red-Black)
- The tree maintains elements in sorted order (in-order traversal gives sorted sequence)
- Duplicate values are allowed and counted separately

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## References

- Stadnik, V. "Fast Sequential Summation Algorithms Using Augmented Data Structures"
