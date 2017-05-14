defmodule Table do
  @moduledoc """
  A module to work with tables and export them to three different formats
  """

  defstruct [table: []]
    
  defp times(xs, 0, _func), do: xs
  defp times(xs, n, func), do: times(func.(xs), n - 1, func)
  
  defp max_len_sublist(xs), do: xs |> Enum.map(fn x -> length x end) |> Enum.max

  defp transpose(xs) do
    xs 
    |> List.zip 
    |> Enum.map(&Tuple.to_list/1)
  end

  @docp """
  CSV helper functions
  """
  defp my_to_string(element) when is_binary(element) do
    cond do
      String.contains?(element, "\"") -> "\"" <> Regex.replace(~r/\"/, element, "\"\"")  <> "\""
      String.contains?(element, ",") -> "\"" <> element <> "\""
      String.contains?(element, "\n") -> "\"" <> element <> "\""
      true -> element
    end
  end
  defp my_to_string(element) when is_number(element) or is_nil(element),
    do: element |> to_string
  
  defp csv_row(row) do
    [
      row
      |> Enum.map(&my_to_string/1)
      |> Enum.intersperse(",")
    ]
  end

  defp csv(table) do
   table.table
   |> Enum.map(&csv_row/1)
   |> Enum.intersperse("\n")
  end
  
  @docp """
  HTML helper functions
  """
  defp html_to_string(element) when is_binary(element) do
    "\""
    <>
    (element
    |> String.replace(~r/>/, "&gt;")
    |> String.replace(~r/</, "&lt;")
    |> String.replace(~r/&/, "&amp;"))
    <>
    "\""
  end
  defp html_to_string(element) when is_number(element) or is_nil(element), do: element |> to_string

  defp render_list(list) do
      Enum.map(list, fn row ->
                     "<tr>"
                     <>
                     (row |> Enum.map(fn element ->
                                     "<td>"
                                     <>
                                     html_to_string(element)
                                     <>
                                     "</td>\n" end) |> Enum.join)
                     <> "</tr>\n" end)
  end

  defp html(table) do
    [
      "<table>",
      render_list(table.table),
     "</table>"
    ]
  end

  @docp """
  Markdown helper functions
  """
  defp render_md_element(element) when is_binary(element) do
    element
    |> String.replace(~r/\\/, "\\\\")
    |> String.replace(~r/\*/, "\\*")
    |> String.replace(~r/\_/, "\\_")
    |> String.replace(~r/\{/, "\\{")
    |> String.replace(~r/\}/, "\\}")
    |> String.replace(~r/\|/, "\\|")
    |> String.replace(~r/\[/, "\\[")
    |> String.replace(~r/\]/, "\\]")
    |> String.replace(~r/\(/, "\\(")
    |> String.replace(~r/\)/, "\\)")
    |> String.replace(~r/\#/, "\\#")
    |> String.replace(~r/\+/, "\\+")
    |> String.replace(~r/\-/, "\\-")
    |> String.replace(~r/\./, "\\.")
    |> String.replace(~r/\!/, "\\!")
    |> String.replace(~r/&/, "&amp;")
    |> String.replace(~r/>/, "&gt;")
    |> String.replace(~r/</, "&lt;")
  end
  defp render_md_element(element), do: html_to_string(element)
  defp render_md(list) do
    "|" <> (list
            |> Enum.map(&render_md_element/1)
            |> Enum.intersperse("|")
            |> Enum.join) <> "|"
  end

  # def md(table) when length(table.table) == 1, do: [ render_md(table.table[0]) ]
  defp md(table) do
    [
      render_md(table.table |> hd) <> "\n",
      ("|-" |> String.duplicate((table |> Table.size |> elem(1)) + 1)
            |> String.trim("-")) <> "\n",
            table.table |> List.delete(table.table |> hd) 
            |> Enum.map(&render_md/1)
            |> Enum.intersperse("\n")
    ]
  end

  def new(), do: %Table{}
  def new(list) do
    %Table{table: Enum.map(list, fn x ->
                  times(x, (max_len_sublist(list) - (length x)), fn xs -> xs ++ [nil] end)
                  end)}
  end

  def size(table) do
    {(length table.table), table.table
                           |> Enum.map(fn a -> length a end)
                           |> Enum.max}
  end

  def to_list(%Table{table: []}), do: []
  def to_list(table) do
    table.table
  end
  
  def insert_row(table, row \\ [], position \\ :last) 
  def insert_row(table, row, position) when position == :last,
    do: Table.new(List.insert_at(table.table, length(table.table), row))
  def insert_row(table, row, position), do: Table.new(List.insert_at(table.table, position - 1, row))

  def insert_column(table, column \\ [], position \\ :last),
    do: Table.new(transpose(insert_row(%Table{table: transpose(table.table)}, column, position).table))
  
  def delete_row(table, position \\ :last)
  def delete_row(table, position) when position == :last do
    {Table.new(table.table 
               |> List.pop_at(length(table.table) - 1, [])
               |> elem(1)),
     table.table
     |> List.pop_at(length(table.table) - 1, [])
     |> elem(0)}
  end
  def delete_row(table, position) do
    {Table.new(table.table
               |> List.pop_at(position - 1, [])
               |> elem(1)),
    table.table
    |> List.pop_at(position - 1, [])
    |> elem(0)}
  end

  def delete_column(table, position \\ :last) do
    {%Table{table: transpose((%Table{table: transpose(table.table)}
                               |> delete_row(position)
                               |> elem(0)).table)},
    %Table{table: transpose(table.table)}
    |> delete_row(position)
    |> elem(1)}
  end
 
  # indexing from 1
  def cell(_table, {row, column}) when row < 1 or column < 1, do: nil
  def cell(table, {row, column}) do
    case Enum.at(table.table, row - 1) do
      nil -> nil
      _ -> table.table
           |> Enum.at(row - 1)
           |> Enum.at(column - 1)
    end
  end
  
  def overwrite_cell(table, pos, value \\ nil)
  def overwrite_cell(%Table{table: table}, _pos, _value) when table == [], do: Table.new(table)
  def overwrite_cell(table, {row, column}, value) when is_number(value) or is_nil(value) or is_binary(value) do
    {new_table, deleted_row} = Table.delete_row(table, row)
    Table.insert_row(new_table, List.replace_at(deleted_row, column - 1, value), row)
  end
  def overwrite_cell(table, {row, column}, value) when is_function(value) do
    {new_table, deleted_row} = Table.delete_row(table, row)
    Table.insert_row(new_table, List.update_at(deleted_row, column - 1, value), row)
  end
  def overwrite_cell(_table, {_row, _column}, _value), do: {:error, "Invalid value"}

  def format_as(table, format) when format == :csv, do: csv(table)
  def format_as(table, format) when format == :html, do: html(table)
  def format_as(table, format) when format == :md, do: md(table)
  def format_as(_table, _format), do: {:error, "Invalid format!"}
end
