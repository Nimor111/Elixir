defmodule SequenceTest do
  use ExUnit.Case

  test "can create sequence" do
    assert %Sequence{state: 0, generator: &{&1, &1 + 1}}
  end

  test "can generate finitee sequence" do
    assert {1, seq} = finite(1) |> Sequence.generate
    refute seq |> Sequence.generate
  end

  test "can generate infinite sequence" do
    assert {2, seq} = infinite(2) |> Sequence.generate
    assert {3, _} = seq |> Sequence.generate
  end

  test "can generate next sequence" do
    assert {4, _} = infinite(3) |> Sequence.generate_next |> Sequence.generate
  end

  test "can generate next value" do
    assert {5, seq} = infinite(5) |> Sequence.generate
    assert seq |> Sequence.generate_value == 6
  end

  test "can limit sequence" do
    assert {6, next} = infinite(6) |> Sequence.limit(1)|> Sequence.generate
    assert next |> Sequence.generate_next == nil
  end

  test "can advance sequence" do
    assert infinite(7) |> Sequence.advance(8) |> Sequence.generate_value == 15
  end

  test "can cycle finite sequences" do
    assert {9, next} = finite(9) |> Sequence.cycle |> Sequence.generate
    assert next |> Sequence.generate_value == 9
  end

  test "can repeat finite sequences" do
    assert {10, next} = finite(10) |> Sequence.repeat(2) |> Sequence.generate
    assert {10, next_next} = next |> Sequence.generate
    assert next_next |> Sequence.generate_next == nil
  end

  test "can concatenate 2 sequences" do
    assert {11, next} = Sequence.concatenate(finite(11), finite(12)) |> Sequence.generate
    assert {12, next_next} = next |> Sequence.generate()
    assert next_next |> Sequence.generate == nil
  end

  test "propery implements Enumerable for finite sequences" do
    assert finite(13) |> Enum.to_list == [13]
  end

  test "propery implements Enumerable for infinite sequences" do
    assert infinite(14) |> Enum.take(2) == [14, 15]
  end

  #Test helpers

  defp finite(number), do: %Sequence{state: number, generator: &{&1, nil}}

  defp infinite(number), do: %Sequence{state: number, generator: &{&1, &1 + 1}}
end
