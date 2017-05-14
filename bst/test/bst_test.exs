defmodule BstTest do
  use ExUnit.Case
  doctest Bst

  test "can create empty BST with BST.new" do
    assert Bst.new() == %Bst{}
  end

  test "can insert element into Bst" do
    assert Bst.new() |> Bst.insert(4) |> Bst.root == 4 
  end

  test "can get root" do
    assert Bst.new() |> Bst.root == nil
  end

  test "can get elements" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(5) |> Bst.insert(3) |> Bst.inorder == [3, 4, 5]
  end

  test "can insert elements correctly" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(3) |> Bst.inorder == [3, 4]
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(5) |> Bst.inorder == [4, 5]
  end

  test "can delete elements correctly" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(3) |> Bst.insert(5) |> Bst.delete(4) |> Bst.inorder == [3] 
  end

  test "can find smaller element" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(5) |> Bst.insert(3) |> Bst.find(3) == true
  end

  test "can find root element" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(5) |> Bst.insert(3) |> Bst.find(4) == true
  end

  test "can find bigger element" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(5) |> Bst.insert(3) |> Bst.find(5) == true
  end

  test "can get level of element" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(3) |> Bst.insert(2) |> Bst.get_level(2) == 3
  end

  test "can BFS" do
    assert Bst.new() |> Bst.insert(4) |> Bst.insert(3) |> Bst.insert(2)
                     |> Bst.insert(5) |> Bst.insert(6) |> Bst.bfs == [4, 3, 5, 2, 6]
  end
end
