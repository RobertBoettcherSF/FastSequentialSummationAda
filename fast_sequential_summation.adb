-- 0.02 Fixed version with complete implementations
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Fast_Sequential_Summation is

    -- Helper procedure to update node statistics
    procedure Update_Node_Stats(Node : in out Node_Ptr) is
    begin
        if Node = null then
            return;
        end if;
        
        Node.Sum := Node.Value;
        Node.Count := 1;
        
        if Node.Left /= null then
            Node.Sum := Node.Sum + Node.Left.Sum;
            Node.Count := Node.Count + Node.Left.Count;
        end if;
        
        if Node.Right /= null then
            Node.Sum := Node.Sum + Node.Right.Sum;
            Node.Count := Node.Count + Node.Right.Count;
        end if;
    end Update_Node_Stats;

    -- Helper function to get the rank (position) of a node in in-order traversal
    function Get_Rank(Node : Node_Ptr) return Integer is
        Rank : Integer := 0;
    begin
        if Node = null then
            return 0;
        end if;
        
        -- Count nodes in left subtree
        if Node.Left /= null then
            Rank := Rank + Node.Left.Count;
        end if;
        
        -- Add 1 for this node
        Rank := Rank + 1;
        
        return Rank;
    end Get_Rank;

    -- Helper procedure for in-order insertion to maintain sorted order
    procedure Insert_Recursive(Current : in out Node_Ptr; Value : Integer; Inserted : out Boolean) is
        New_Node : Node_Ptr;
    begin
        Inserted := False;
        
        if Current = null then
            New_Node := new Node'(Value, Value, 1, null, null);
            Current := New_Node;
            Inserted := True;
            return;
        end if;
        
        if Value < Current.Value then
            Insert_Recursive(Current.Left, Value, Inserted);
            if Inserted then
                Update_Node_Stats(Current);
            end if;
        elsif Value > Current.Value then
            Insert_Recursive(Current.Right, Value, Inserted);
            if Inserted then
                Update_Node_Stats(Current);
            end if;
        else
            -- Value already exists, update count and sum
            Current.Count := Current.Count + 1;
            Current.Sum := Current.Sum + Value;
            Inserted := True;
        end if;
    end Insert_Recursive;

    -- Insert a value into the tree
    procedure Insert(Tree : in out BPlusTree; Value : Integer) is
        Inserted : Boolean;
    begin
        Insert_Recursive(Tree.Root, Value, Inserted);
    end Insert;

    -- Helper function to compute sum in a range recursively
    function Compute_Sum_Recursive(Node : Node_Ptr; Start_Rank, End_Rank : Integer; 
                                   Current_Rank : Integer) return Integer is
        Left_Count : Integer := 0;
        Node_Rank : Integer := 0;
        Right_Count : Integer := 0;
        Sum_Result : Integer := 0;
    begin
        if Node = null then
            return 0;
        end if;
        
        -- Calculate counts for subtrees
        if Node.Left /= null then
            Left_Count := Node.Left.Count;
        end if;
        
        if Node.Right /= null then
            Right_Count := Node.Right.Count;
        end if;
        
        Node_Rank := Current_Rank + Left_Count + 1;
        
        -- Check if current node is in range
        if Node_Rank >= Start_Rank and Node_Rank <= End_Rank then
            Sum_Result := Sum_Result + Node.Value;
        end if;
        
        -- Recurse left if needed
        if Start_Rank < Node_Rank then
            Sum_Result := Sum_Result + Compute_Sum_Recursive(Node.Left, Start_Rank, End_Rank, Current_Rank);
        end if;
        
        -- Recurse right if needed
        if End_Rank > Node_Rank then
            Sum_Result := Sum_Result + Compute_Sum_Recursive(Node.Right, Start_Rank, End_Rank, Node_Rank);
        end if;
        
        return Sum_Result;
    end Compute_Sum_Recursive;

    -- Compute the sum of elements from Start_Rank to End_Rank
    function Compute_Sum(Tree : BPlusTree; Start_Rank, End_Rank : Integer) return Integer is
    begin
        if Tree.Root = null then
            return 0;
        end if;
        
        -- Validate ranks
        if Start_Rank > End_Rank or Start_Rank < 1 or End_Rank > Tree.Root.Count then
            return 0;
        end if;
        
        return Compute_Sum_Recursive(Tree.Root, Start_Rank, End_Rank, 0);
    end Compute_Sum;

    -- Helper function to compute sum of squares for standard deviation
    function Compute_Sum_Of_Squares_Recursive(Node : Node_Ptr; Start_Rank, End_Rank : Integer; 
                                               Current_Rank : Integer) return Float is
        Left_Count : Integer := 0;
        Node_Rank : Integer := 0;
        Right_Count : Integer := 0;
        Sum_Sq : Float := 0.0;
    begin
        if Node = null then
            return 0.0;
        end if;
        
        -- Calculate counts for subtrees
        if Node.Left /= null then
            Left_Count := Node.Left.Count;
        end if;
        
        if Node.Right /= null then
            Right_Count := Node.Right.Count;
        end if;
        
        Node_Rank := Current_Rank + Left_Count + 1;
        
        -- Check if current node is in range
        if Node_Rank >= Start_Rank and Node_Rank <= End_Rank then
            Sum_Sq := Sum_Sq + Float(Node.Value) ** 2;
        end if;
        
        -- Recurse left if needed
        if Start_Rank < Node_Rank then
            Sum_Sq := Sum_Sq + Compute_Sum_Of_Squares_Recursive(Node.Left, Start_Rank, End_Rank, Current_Rank);
        end if;
        
        -- Recurse right if needed
        if End_Rank > Node_Rank then
            Sum_Sq := Sum_Sq + Compute_Sum_Of_Squares_Recursive(Node.Right, Start_Rank, End_Rank, Node_Rank);
        end if;
        
        return Sum_Sq;
    end Compute_Sum_Of_Squares_Recursive;

    -- Calculate the mean value of elements in the tree
    function Calculate_Mean(Tree : BPlusTree) return Float is
        Total_Sum : Integer;
        Total_Count : Integer;
    begin
        if Tree.Root = null then
            return 0.0;
        end if;
        
        Total_Count := Tree.Root.Count;
        Total_Sum := Compute_Sum(Tree, 1, Total_Count);
        return Float(Total_Sum) / Float(Total_Count);
    end Calculate_Mean;

    -- Calculate the standard deviation of elements in the tree
    function Calculate_Standard_Deviation(Tree : BPlusTree) return Float is
        Mean : Float;
        Sum_Squared_Diffs : Float := 0.0;
        Total_Count : Integer;
        Sum_Of_Squares : Float;
    begin
        if Tree.Root = null or Tree.Root.Count <= 1 then
            return 0.0;
        end if;
        
        Total_Count := Tree.Root.Count;
        Mean := Calculate_Mean(Tree);
        
        -- Compute sum of squares of all elements
        Sum_Of_Squares := Compute_Sum_Of_Squares_Recursive(Tree.Root, 1, Total_Count, 0);
        
        -- Variance = (sum of squares / n) - mean^2
        -- Standard deviation = sqrt(variance)
        Sum_Squared_Diffs := (Sum_Of_Squares / Float(Total_Count)) - (Mean ** 2);
        
        -- Handle potential floating point errors that could make variance negative
        if Sum_Squared_Diffs < 0.0 then
            Sum_Squared_Diffs := 0.0;
        end if;
        
        return Sqrt(Sum_Squared_Diffs);
    end Calculate_Standard_Deviation;

end Fast_Sequential_Summation;
