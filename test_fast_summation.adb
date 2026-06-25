-- Test program for Fast_Sequential_Summation package
with Ada.Text_IO; use Ada.Text_IO;
with Fast_Sequential_Summation; use Fast_Sequential_Summation;

procedure Test_Fast_Summation is
    Tree : BPlusTree;
    Sum_Result : Integer;
    Mean_Result : Float;
    StdDev_Result : Float;
begin
    Put_Line("Testing Fast Sequential Summation Package");
    Put_Line("===========================================");
    
    -- Test 1: Insert values and compute sum
    Put_Line("Test 1: Inserting values 10, 20, 30, 40, 50");
    Insert(Tree, 10);
    Insert(Tree, 20);
    Insert(Tree, 30);
    Insert(Tree, 40);
    Insert(Tree, 50);
    
    Sum_Result := Compute_Sum(Tree, 1, 5);
    Put_Line("Sum of all elements (ranks 1-5): " & Integer'Image(Sum_Result));
    
    Sum_Result := Compute_Sum(Tree, 2, 4);
    Put_Line("Sum of elements at ranks 2-4: " & Integer'Image(Sum_Result));
    
    -- Test 2: Calculate mean
    Put_Line("\nTest 2: Calculating mean");
    Mean_Result := Calculate_Mean(Tree);
    Put_Line("Mean of all elements: " & Float'Image(Mean_Result));
    
    -- Test 3: Calculate standard deviation
    Put_Line("\nTest 3: Calculating standard deviation");
    StdDev_Result := Calculate_Standard_Deviation(Tree);
    Put_Line("Standard deviation: " & Float'Image(StdDev_Result));
    
    -- Test 4: Empty tree
    Put_Line("\nTest 4: Empty tree");
    declare
        Empty_Tree : BPlusTree;
        Empty_Sum : Integer;
        Empty_Mean : Float;
        Empty_StdDev : Float;
    begin
        Empty_Sum := Compute_Sum(Empty_Tree, 1, 1);
        Put_Line("Sum of empty tree: " & Integer'Image(Empty_Sum));
        
        Empty_Mean := Calculate_Mean(Empty_Tree);
        Put_Line("Mean of empty tree: " & Float'Image(Empty_Mean));
        
        Empty_StdDev := Calculate_Standard_Deviation(Empty_Tree);
        Put_Line("Standard deviation of empty tree: " & Float'Image(Empty_StdDev));
    end;
    
    -- Test 5: Single element
    Put_Line("\nTest 5: Single element tree");
    declare
        Single_Tree : BPlusTree;
        Single_Sum : Integer;
        Single_Mean : Float;
        Single_StdDev : Float;
    begin
        Insert(Single_Tree, 42);
        Single_Sum := Compute_Sum(Single_Tree, 1, 1);
        Put_Line("Sum of single element: " & Integer'Image(Single_Sum));
        
        Single_Mean := Calculate_Mean(Single_Tree);
        Put_Line("Mean of single element: " & Float'Image(Single_Mean));
        
        Single_StdDev := Calculate_Standard_Deviation(Single_Tree);
        Put_Line("Standard deviation of single element: " & Float'Image(Single_StdDev));
    end;
    
    -- Test 6: Duplicate values
    Put_Line("\nTest 6: Duplicate values");
    declare
        Dup_Tree : BPlusTree;
        Dup_Sum : Integer;
    begin
        Insert(Dup_Tree, 5);
        Insert(Dup_Tree, 5);
        Insert(Dup_Tree, 5);
        Dup_Sum := Compute_Sum(Dup_Tree, 1, 3);
        Put_Line("Sum of three 5s: " & Integer'Image(Dup_Sum));
    end;
    
    Put_Line("\nAll tests completed!");
end Test_Fast_Summation;
