-- 0.01 Initial version
package Fast_Sequential_Summation is
    -- Node type for B+ tree
    type Node;
    type Node_Ptr is access Node;
    type Node is record
        Value : Integer;  -- Element value
        Sum   : Integer;  -- Precomputed sum of subtree
        Count : Integer;  -- Number of elements in subtree
        Left  : Node_Ptr; -- Left child
        Right : Node_Ptr; -- Right child
    end record;

    -- B+ Tree type
    type BPlusTree is record
        Root : Node_Ptr; -- Root of the tree
    end record;

    -- Insert a value into the tree
    procedure Insert(Tree : in out BPlusTree; Value : Integer);

    -- Compute the sum of elements from Start_Rank to End_Rank
    function Compute_Sum(Tree : BPlusTree; Start_Rank, End_Rank : Integer) return Integer;

    -- Compute the mean value of elements in the tree
    function Calculate_Mean(Tree : BPlusTree) return Float;

    -- Compute the standard deviation of elements in the tree
    function Calculate_Standard_Deviation(Tree : BPlusTree) return Float;
end Fast_Sequential_Summation;
