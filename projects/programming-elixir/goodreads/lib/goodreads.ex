defmodule Goodreads do
  require Logger
  # , only: [parse: 1], but missing sigil_x
  import SweetXml

  @base_uri "https://www.goodreads.com/review/list_rss/"
  @default_shelf "#ALL#"
  @shelves ["#ALL#", "read", "currently-reading", "to-read", "on-deck"]

  # const URI = `https://www.goodreads.com/review/list_rss/${GOODREADS_USER}`;
  # const shelves = ["#ALL#", "read", "currently-reading", "to-read", "on-deck"];
  # page is "1" indexed
  # key seems optional
  # const asXML = await fetcherXML(URI, { key: GOODREADS_KEY, shelf, page });
  # https://www.goodreads.com/review/list_rss/6883912?shelf=%23ALL%23

  @moduledoc """
  Documentation for `Goodreads`.
  """

  @doc """
  Goodreads feed fetch.

  ## Examples
      iex> Goodreads.main([])
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

  # Define a process function to handle the parsed arguments
  def process(:help) do
    IO.puts("""
    usage:  goodreads -h|--help
            goodreads [--shelf|-s <shelf>] where shelf is one of #{Enum.join(@shelves, ", ")}
    """)
  end

  def process({:shelf, shelf}) do
    page = 1
    Logger.info("Fetching Goodreads feed: #{feed_url(shelf, page)} shelf:#{shelf}")

    HTTPoison.get!(feed_url(shelf, page))
    |> parse_feed()
    |> pretty_print()
  end

  def process({:error, :invalid_shelf}), do: IO.puts("Error: Invalid shelf provided.")
  def process(_), do: IO.puts("Error: Invalid arguments.")

  def pretty_print(%{title: title, description: _description, link: link, items: items}) do
    IO.puts("Goodreads Feed (page 1)")
    IO.puts("  #{title} (#{link})")

    Enum.each(items, &pretty_print_item/1)
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

  def feed_url(shelf, page) do
    goodreads_user = Application.fetch_env!(:goodreads, :goodreads_user)
    # baseURI already has trailing slash
    params = URI.encode_query(%{shelf: shelf, page: page})
    "#{@base_uri}#{goodreads_user}?#{params}"
  end
end
