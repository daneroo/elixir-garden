defmodule GoodreadsTest do
  use ExUnit.Case
  # doctest Goodreads

  test "should return URL with base URI, and numeric path (user) and default params" do
    url = Goodreads.feed_url()

    # assert starts with base URI
    assert String.starts_with?(url, "https://www.goodreads.com/review/list_rss/")

    parsed_uri = URI.parse(url)

    # assert path ends with numeric user id
    assert parsed_uri.path =~ ~r/\/\d+$/
    # assert params are decoded properly
    decode_query = URI.decode_query(parsed_uri.query)
    assert decode_query == %{"page" => "1", "shelf" => "#ALL#"}
  end

  # Define the data for your tests
  @shelves ["read", "#ALL"]
  @pages [1, 2]
  # Iterate over the data to generate tests
  for shelf <- @shelves, page <- @pages do
    @shelf shelf
    @page page

    test "feed_url should encode/decode shelf '#{@shelf}' and page #{@page} params correctly" do
      url = Goodreads.feed_url(@shelf, @page)
      parsed_uri = URI.parse(url)

      # assert params are decoded properly
      decode_query = URI.decode_query(parsed_uri.query)
      assert decode_query == %{"page" => Integer.to_string(@page), "shelf" => @shelf}
    end
  end
end
