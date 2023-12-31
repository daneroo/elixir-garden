defmodule Goodreads do
  require Logger
  # , only: [parse: 1], but missing sigil_x
  import SweetXml

  @base_uri "https://www.goodreads.com/review/list_rss/"
  @default_shelf "#ALL#"
  @shelves ["#ALL#", "read", "currently-reading", "to-read", "on-deck"]

  @moduledoc """
  Documentation for `Goodreads`.
  """

  @doc """
  Goodreads feed fetch.
  """
  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def parse_args(argv) do
    options = [help: :boolean, shelf: :string]

    {opts, _args, _invalid} =
      OptionParser.parse(argv, switches: options, aliases: [h: :help, s: :shelf])

    # if invalid != [] do
    #   # Handle unknown flags by returning an error
    #   {:error, {:unknown_flags, invalid}}

    case opts do
      [help: true] ->
        :help

      [shelf: shelf] when shelf in @shelves ->
        {:shelf, shelf}

      [shelf: shelf] ->
        # should be stderr, and cause non-zero exit code
        IO.puts("Error: Invalid shelf provided: #{shelf}")
        :help

      [] ->
        {:shelf, @default_shelf}
    end
  end

  @doc """
  process for show help args

  """
  @help_output """
  usage:
    goodreads -h|--help
    goodreads [--shelf|-s <shelf>] where shelf is one of #ALL#, read, currently-reading, to-read, on-deck
  """
  def process(:help) do
    IO.puts(@help_output)
  end

  def process({:shelf, shelf}), do: process_page({:shelf, shelf})
  def process({:error, :invalid_shelf}), do: IO.puts("Error: Invalid shelf provided.")
  def process(_), do: IO.puts("Error: Invalid arguments.")

  def pretty_print(%{title: title, description: _description, link: link, items: items}) do
    IO.puts("  #{title} (#{link})")
    Enum.each(items, &pretty_print_item/1)
  end

  # recursive page iteration until no more items
  def process_page({:shelf, shelf}, page \\ 1) do
    # safety measure for recursion
    max_pages = 20

    # This was simpler before recursion
    # HTTPoison.get!(feed_url(shelf, page))
    # |> parse_feed()
    # |> pretty_print()

    feed_data =
      HTTPoison.get!(feed_url(shelf, page))
      |> parse_feed()

    Logger.debug(
      "Fetching Goodreads feed: #{feed_url(shelf, page)} shelf:#{shelf} page:#{page} has #{length(feed_data.items)} items"
    )

    if page > max_pages or Enum.empty?(feed_data.items) do
      Logger.debug("No more items to fetch, stopping at page: #{page}")
      :done
    else
      feed_data |> pretty_print()
      process_page({:shelf, shelf}, page + 1)
    end
  end

  def pretty_print_item(%{title: title, author_name: author_name, user_read_at: nil}) do
    IO.puts("    #{title} by #{author_name}")
  end

  def pretty_print_item(%{title: title, author_name: author_name, user_read_at: user_read_at}) do
    IO.puts("    #{title} by #{author_name} on #{user_read_at}")
  end

  def parse_feed(%HTTPoison.Response{status_code: 200, body: body}) do
    document = SweetXml.parse(body)

    title = document |> xpath(~x"./channel/title/text()"l) |> to_string
    description = document |> xpath(~x"./channel/description/text()"l) |> to_string
    link = document |> xpath(~x"./channel/link/text()"l) |> to_string

    items =
      document
      |> xpath(~x"./channel/item"l)
      |> Enum.map(&parse_item/1)

    %{
      title: title,
      description: description,
      link: link,
      items: items
    }
  end

  defp parse_item(item) do
    # Extract the title using xpath, assuming item is a map or struct that SweetXml can parse
    title = item |> xpath(~x"./title/text()") |> to_string
    author_name = item |> xpath(~x"./author_name/text()") |> to_string

    user_read_at =
      item
      |> xpath(~x"./user_read_at/text()")
      |> to_string()
      |> parse_date()

    # IO.puts("#{title}:  #{user_read_at_raw} -> #{user_read_at}")

    %{
      title: title,
      author_name: author_name,
      user_read_at: user_read_at
    }
  end

  defp parse_date(date_string) when date_string == "", do: nil

  defp parse_date(date_string) do
    format = "{RFC1123}"

    case Timex.parse(date_string, format) do
      {:ok, datetime} ->
        datetime

      # If there's an error, just return nil
      {:error, reason} ->
        IO.puts("Error parsing date: #{date_string}: #{reason}")
        nil
    end
  end

  @doc """
  Generates a complete Goodreads feed URL with the given shelf and page parameters.

  ## Examples

      iex> Goodreads.feed_url()
      "https://www.goodreads.com/review/list_rss/6883912?shelf=%23ALL%23&page=1"

      iex> Goodreads.feed_url("read", 1)
      "https://www.goodreads.com/review/list_rss/6883912?shelf=read&page=1"

      iex> Goodreads.feed_url("#ALL#", 2)
      "https://www.goodreads.com/review/list_rss/6883912?shelf=%23ALL%23&page=2"

  """
  def feed_url(shelf \\ "#ALL#", page \\ 1) do
    goodreads_user = Application.fetch_env!(:goodreads, :goodreads_user)
    # baseURI already has trailing slash
    params = URI.encode_query(%{shelf: shelf, page: page})
    "#{@base_uri}#{goodreads_user}?#{params}"
  end
end
