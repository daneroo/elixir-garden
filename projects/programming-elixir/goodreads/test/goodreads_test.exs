defmodule GoodreadsTest do
  use ExUnit.Case
  doctest Goodreads

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "should return URL with base URI, and numeric path (user)" do
    url = Goodreads.feed_url()
    assert String.starts_with?(url, "https://www.goodreads.com/review/list_rss/")
    assert Regex.match?(~r/\/\d+$/, url)
  end
end
