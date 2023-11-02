defmodule Issues.Table do
  @columns ["number", "created_at", "title"]

  @moduledoc """
  Format the list of isues as a table
  e.g. Issues.GithubIssues.fetch("elixir-lang", "elixir")
    Issues.Table.format(...)
   #   | created_at           | title
  ​ 	----+----------------------+-----------------------------------------
  ​ 	889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
  ​ 	892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
  ​ 	893 | 2013-03-21T06:23:00Z | mix test time reports
  ​ 	898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors

  """

  def format(issues) do
    # Getting a list of %{number:,created_at:,title:,...} maps

    values_as_list_of_lists = convert_to_list_of_lists(issues)
    prepend_with_column_headers = [@columns | values_as_list_of_lists]
    widths = max_column_widths(prepend_with_column_headers)
    padded = pad_list_of_lists(prepend_with_column_headers, widths)

    padded
    |> Enum.map_join("\n", fn issue_as_row ->
      Enum.join(issue_as_row, " | ")
    end)
  end

  def pad_list_of_lists(list_of_lists, widths) do
    Enum.map(list_of_lists, fn row ->
      pad_row(row, widths)
    end)
  end

  def pad_row(row, widths) do
    Enum.zip(row, widths)
    |> Enum.map(fn {value, width} ->
      String.pad_trailing(to_string(value), width)
    end)
  end

  def max_column_widths(rows) do
    # Initialize the accumulator with a list of zeros, with the same length as the number of columns in the first row
    zeroes = List.duplicate(0, length(List.first(rows)))

    Enum.reduce(rows, zeroes, fn row, acc ->
      Enum.zip(row, acc)
      |> Enum.map(fn {value, max_width} ->
        max(String.length(to_string(value)), max_width)
      end)
    end)
  end

  # incoming issues is a list of maps: %{number:,created_at:,title:,...}
  # convert to a list of lists: [[number,created_at,title,...],...]
  def convert_to_list_of_lists(issues) do
    Enum.map(issues, fn issue ->
      Enum.map(@columns, fn column ->
        Map.get(issue, column)
      end)
    end)
  end
end
