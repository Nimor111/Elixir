defmodule Deque do
  defstruct content: [], len: 0

  def new(), do: %Deque{}

  def size(deque), do: deque.len

  def push_front(deque, element) do
    %Deque{content: [element | deque.content ], len: deque.len + 1}
  end

  def push_back(deque, element) do
    %Deque{content: [element | deque.content |> Enum.reverse ] |> Enum.reverse, len: deque.len + 1}
  end

  def pop_back(%Deque{content: [], len: _}), do: %Deque{}
  def pop_back(%Deque{content: xs, len: len}) do
    xs = xs |> Enum.reverse 
    [_ | xs] = xs
    %Deque{content: xs |> Enum.reverse, len: len - 1}
  end

  def pop_front(%Deque{content: [], len: _}), do: %Deque{}
  def pop_front(%Deque{content: [_ | xs], len: len}), do: %Deque{content: xs, len: len - 1}

  def last(%Deque{content: [], len: _}), do: nil
  def last(%Deque{content: xs, len: _}), do: xs |> Enum.reverse |> hd

  def first(%Deque{content: [], len: _}), do: nil
  def first(%Deque{content: [x | _], len: _}), do: x

  def access_at(deque, n) do
    Enum.at(deque.content, n)
  end

  def assign_at(deque, n, element \\ nil) do
    %Deque{content: deque.content |> List.to_tuple |> put_elem(n, element) |> Tuple.to_list,
           len: deque.len}
  end
end

defimpl Collectable, for: Deque do
  def into(original) do
    {original, fn
        deque, {:cont, v} -> Deque.push_back(deque, v)
        deque, :done -> deque 
        _, :halt -> :ok
    end} 
  end
end

defimpl Enumerable, for: Deque do
  def reduce(deque, acc, fun) do
    do_reduce(deque.content, acc, fun)
  end

  defp do_reduce(_,     {:halt, acc}, _fun),   do: {:halted, acc}
  defp do_reduce(deque,  {:suspend, acc}, fun), do: {:suspended, acc, &do_reduce(deque, &1, fun)}
  defp do_reduce([],    {:cont, acc}, _fun),   do: {:done, acc}
  defp do_reduce([h|t], {:cont, acc}, fun), do: do_reduce(t, fun.(h, acc), fun)
  
  def member?(_, _) do
    { :error, __MODULE__ }
  end

  def count(_) do
    { :error, __MODULE__ }
  end
end
