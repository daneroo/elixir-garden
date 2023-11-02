defmodule TableTest do
  @moduledoc false
  use ExUnit.Case
  # doctest Issues.Case

  import Issues.Table
  # only: [parse_args: 1, sort_into_descending_order: 1]

  test "Formats a list of issues as a table with column headers" do
    issues = [
      %{"number" => 1, "created_at" => "2023-11-02T17:17:00Z", "title" => "Issue 1"},
      %{"number" => 2, "created_at" => "2023-11-02T04:18:27Z", "title" => "Issue 2"}
    ]

    expected =
      [
        "number | created_at           | title  ",
        "1      | 2023-11-02T17:17:00Z | Issue 1",
        "2      | 2023-11-02T04:18:27Z | Issue 2"
      ]
      |> Enum.join("\n")

    assert Issues.Table.format(issues) == expected
  end

  test "should pad each value in each table's row with trailing spaces" do
    list_of_lists = [["abc", "def"], ["ghi", "jkl"]]
    widths = [5, 7]
    expected_result = [["abc  ", "def    "], ["ghi  ", "jkl    "]]

    assert Issues.Table.pad_list_of_lists(list_of_lists, widths) == expected_result
  end

  test "should pad each value in the row with trailing spaces" do
    row = ["123", "abc", "xyz"]
    widths = [5, 4, 6]
    expected = ["123  ", "abc ", "xyz   "]

    assert Issues.Table.pad_row(row, widths) == expected
  end

  test "should return a list of integers representing the maximum width of each column" do
    rows = [
      ["number", "created_at", "title"],
      [1, "2022-01-01T00:00:00Z", "Title 1"],
      [2, "2022-01-02T00:00:00Z", "Title 2"]
    ]

    expected = [6, 20, 7]

    assert Issues.Table.max_column_widths(rows) == expected
  end

  test "should_convert_list_of_issues_to_list_of_lists" do
    issues = [
      %{"number" => 1, "created_at" => "2023-11-02T17:17:00Z", "title" => "Issue 1"},
      %{"number" => 2, "created_at" => "2023-11-02T04:18:27Z", "title" => "Issue 2"}
    ]

    expected = [
      [1, "2023-11-02T17:17:00Z", "Issue 1"],
      [2, "2023-11-02T04:18:27Z", "Issue 2"]
    ]

    assert convert_to_list_of_lists(issues) == expected
  end
end
