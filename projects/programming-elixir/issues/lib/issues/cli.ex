defmodule Issues.CLI do
  use ExUnit.Case
  # doctest Issues

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  e.g.:
    iex -S mix run -e 'Issues.CLI.main(["-h"])'
    iex -S mix run -e 'Issues.CLI.main(["--help"])'
    iex -S mix run -e 'Issues.CLI.main(["elixir-lang", "elixir"])'
    Issues.CLI.main(["elixir-lang", "elixir"])
    Issues.CLI.main(["elixir-lang", "elixir", "3"])
    Issues.CLI.main(["daneroo", "elixir-garden", "3"])

  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts("""
    usage:  issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    IO.puts("Fetching (max) #{count} issues from #{user}/#{project}")

    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_descending_order
    |> Enum.take(count)
    |> Issues.Table.format()
    |> IO.puts()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts("Error fetching from Github: #{message}")
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 -> i2["created_at"] <= i1["created_at"] end)
  end
end
