defmodule Bst do
  @moduledoc """
  A module for a binary search tree
  Making use of funky Elixir comparisons, TODO maybe type checking
  """

  @doc """
  """
  defstruct [:root, :left, :right] 

  def new(), do: %Bst{}

  def root(%Bst{root: nil}), do: nil
  def root(%Bst{root: root}), do: root
  
  # empty tree
  def insert(%Bst{root: nil}, value), do: %Bst{root: value, left: nil, right: nil}
  
  # when we reach a leaf
  def insert(%Bst{root: r, left: nil, right: nil}, value) when value < r,
    do: %Bst{root: r, left: %Bst{root: value}}
  def insert(%Bst{root: r, left: nil, right: nil}, value) when value > r,
    do: %Bst{root: r, right: %Bst{root: value}}
  
  # when we're on an internal node with only a left child 
  def insert(%Bst{root: r, left: l, right: nil}, value) when value > r,
    do: %Bst{root: r, left: l, right: %Bst{root: value}}
  def insert(%Bst{root: r, left: l, right: nil}, value) when value < r,
    do: %Bst{root: r, left: insert(l, value), right: nil}

  # when we're on an internal node with only a right child 
  def insert(%Bst{root: v, left: nil, right: r}, value) when value > v,
    do: %Bst{root: v, left: nil, right: insert(r, value)}
  def insert(%Bst{root: v, left: nil, right: r}, value) when value < v,
    do: %Bst{root: v, left: %Bst{root: value}, right: r}
  
  # when we're on an internal node with two children
  def insert(%Bst{root: v, left: l, right: r}, value) when value < v,
    do: %Bst{root: v, left: insert(l, value), right: r}
  def insert(%Bst{root: v, left: l, right: r}, value) when value > v,
    do: %Bst{root: v, left: l, right: insert(r, value)}
  
  # standard inorder traversal
  def inorder(nil), do: []
  def inorder(tree) do
    inorder(tree.left) ++ [tree.root] ++ inorder(tree.right)
  end

  def find(%Bst{root: v, left: _, right: _}, value) when value == v,
    do: true
  def find(%Bst{root: v, left: %Bst{root: lr, left: ll, right: lri}, right: _}, value) when value < v,
    do: find(%Bst{root: lr, left: ll, right: lri}, value)
  def find(%Bst{root: v, left: _, right: %Bst{root: rr, left: rl, right: rri}}, value) when value > v,
    do: find(%Bst{root: rr, left: rl, right: rri}, value)
  def find(%Bst{}, _), do: false
  
  def get_level(%Bst{root: r, left: _, right: _}, value) when value == r, do: 1
  def get_level(%Bst{root: r, left: %Bst{root: lr, left: ll, right: lri}, right: _}, value) when value < r,
    do: 1 + get_level(%Bst{root: lr, left: ll, right: lri}, value)
  def get_level(%Bst{root: r, left: _, right: %Bst{root: rr, left: rl, right: rri}}, value) when value > r,
    do: 1 + get_level(%Bst{root: rr, left: rl, right: rri}, value)
  def get_level(%Bst{}, _), do: 0
end
