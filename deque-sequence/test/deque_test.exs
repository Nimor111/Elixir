defmodule DequeTest do
  use ExUnit.Case

  test "can create empty deque with Deque.new" do
    assert Deque.new()
  end

  test "the size of empty deque is 0" do
    assert Deque.new() |> Deque.size == 0
  end

  test "when one item is added to an empty deque it size is increased to 1" do
    assert Deque.new() |> Deque.push_back(0) |> Deque.size == 1
    assert Deque.new() |> Deque.push_front(0) |> Deque.size == 1
  end

  test "when we push element to the back it is the last element" do
    assert zero_to_ten() |> Deque.push_back(:new) |> Deque.last == :new
  end

  test "when we push element to the front it is the first element" do
    assert zero_to_ten() |> Deque.push_front(:new) |> Deque.first == :new
  end

  test "we can access element at an index" do
    assert zero_to_ten() |> Deque.access_at(8) == 8
  end

  test "access with invalid index breaks" do
    catch_error zero_to_ten() |> Deque.access_at(false)
  end

  test "we can assign value to a concrete index" do
    assert :new ==
      zero_to_ten()
      |> Deque.assign_at(5, :new)
      |> Deque.access_at(5)
  end

  test "assign with invalid index breaks" do
    catch_error zero_to_ten() |> Deque.assign_at("5")
  end

  test "we have properly implemented Collectable" do
    deque = 0..10 |> Enum.into(Deque.new)
    assert deque |> Deque.access_at(8) == 8
  end

  test "we have properly implemented Enumerable" do
    assert zero_to_ten() |> Enum.to_list == [0,1,2,3,4,5,6,7,8,9,10]
  end

  # Test helpers

  defp zero_to_ten(deque \\ %Deque{}, n \\ 10)
  defp zero_to_ten(deque, 0), do: deque |> Deque.push_front(0)
  defp zero_to_ten(deque, n) do
    deque |> Deque.push_front(n) |> zero_to_ten(n - 1)
  end
end
