defmodule TableTest do
  use ExUnit.Case

  test "Can create empty table" do
    assert Table.new |> Table.to_list == []
  end

  test "Can create table from list" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    assert Table.new(table) |> Table.to_list == table
  end

  test "Can check the size of the table" do
    table = [[1, 2, 3],
             [4, 5, 6]]
    assert Table.new(table) |> Table.size == {2, 3}
  end

  test "Can insert row at position" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    new_table = Table.new(table) |> Table.insert_row([nil, nil, nil], 2) |> Table.to_list
    assert new_table == [[1, 2, 3],
                         [nil, nil, nil],
                         [4, 5, 6],
                         [7, 8, 9]]
  end

  test "Can insert column at position" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    new_table = Table.new(table) |> Table.insert_column([nil, nil, nil], 2) |> Table.to_list
    assert new_table == [[1, nil, 2, 3],
                         [4, nil, 5, 6],
                         [7, nil, 8, 9]]
  end

  test "Can delete row" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    {new_table, row} = Table.new(table) |> Table.delete_row(2)
    new_table = Table.to_list(new_table)
    assert new_table == [[1, 2, 3],
                         [7, 8, 9]]
    assert row == [4, 5, 6]
  end

  test "Can delete column" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    {new_table, column} = Table.new(table) |> Table.delete_column(2)
    new_table = Table.to_list(new_table)
    assert new_table == [[1, 3],
                         [4, 6],
                         [7, 9]]
    assert column == [2, 5, 8]
  end

  test "Can find the value of a cell" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    assert Table.new(table) |> Table.cell({2, 2}) == 5
  end

  test "Can not find cell in empty table" do
    assert Table.new() |> Table.cell({2, 2}) == nil
    assert Table.new() |> Table.cell({0, 0}) == nil
  end

  test "Can overwrite the value of a cell" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    new_table = Table.new(table) |> Table.overwrite_cell({2, 2}, 10) |> Table.to_list
    assert new_table == [[1, 2, 3],
                         [4, 10, 6],
                         [7, 8, 9]]
  end

  test "Can overwrite with function result" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    new_table = Table.new(table) |> Table.overwrite_cell({2, 2}, &(&1 + 10)) |> Table.to_list
    assert new_table == [[1, 2, 3],
                         [4, 15, 6],
                         [7, 8, 9]]
  end

  test "Can't overwrite value of empty table" do
    assert Table.new() |> Table.overwrite_cell({1, 1}) == Table.new()
  end

  test "Can format as csv" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    csv_string = Table.new(table) |> Table.format_as(:csv) |> to_string
    assert csv_string == "1,2,3\n4,5,6\n7,8,9"
  end

  test "Can format as html" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    html_string = Table.new(table) |> Table.format_as(:html) |> to_string
    html_string = html_string |> String.replace(~r{>\s*<}, "><")
    assert html_string == "<table><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td></tr></table>"
  end

  test "Can format as markdown" do
    table = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    md_string = Table.new(table) |> Table.format_as(:md) |> to_string
    assert md_string == "|1|2|3|\n|-|-|-|\n|4|5|6|\n|7|8|9|"
  end

  test "Can escape syms in markdown" do
    table = [["a>b","||","(arr[4]&1)==0","&&","p-7"],
             ["Are", "those", "some", "magic", "incantations?"]]
    md_string = Table.new(table) |> Table.format_as(:md) |> to_string
    assert md_string == "|a&gt;b|\\|\\||\\(arr\\[4\\]&amp;1\\)==0|&amp;&amp;|p\\-7|\n|-|-|-|-|-|\n|Are|those|some|magic|incantations?|"
  end
end
