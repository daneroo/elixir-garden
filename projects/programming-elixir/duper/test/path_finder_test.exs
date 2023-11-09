defmodule Duper.PathFinderTest do
  use ExUnit.Case
  alias Duper.PathFinder

  test "should find some known files" do
    all_paths = collect_paths_until_nil()
    # IO.puts("all_paths: #{inspect(all_paths)}")
    known_files = ["./test/path_finder_test.exs", "./mix.exs", "./README.md"]

    Enum.each(known_files, fn file ->
      assert Enum.member?(all_paths, file), "#{file} should be in the path list"
    end)
  end

  defp collect_paths_until_nil(acc \\ [])

  defp collect_paths_until_nil(acc) do
    case PathFinder.next_path() do
      nil -> Enum.reverse(acc)
      path -> collect_paths_until_nil([path | acc])
    end
  end
end
