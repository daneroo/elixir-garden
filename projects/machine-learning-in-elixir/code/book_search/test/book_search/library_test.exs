#---
# Excerpted from "Machine Learning in Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/smelixir for more book information.
#---
defmodule BookSearch.LibraryTest do
  use BookSearch.DataCase

  alias BookSearch.Library

  describe "books" do
    alias BookSearch.Library.Book

    import BookSearch.LibraryFixtures

    @invalid_attrs %{author: nil, description: nil, embedding: nil, title: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Library.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Library.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{author: "some author", description: "some description", embedding: "some embedding", title: "some title"}

      assert {:ok, %Book{} = book} = Library.create_book(valid_attrs)
      assert book.author == "some author"
      assert book.description == "some description"
      assert book.embedding == "some embedding"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{author: "some updated author", description: "some updated description", embedding: "some updated embedding", title: "some updated title"}

      assert {:ok, %Book{} = book} = Library.update_book(book, update_attrs)
      assert book.author == "some updated author"
      assert book.description == "some updated description"
      assert book.embedding == "some updated embedding"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_book(book, @invalid_attrs)
      assert book == Library.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Library.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Library.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Library.change_book(book)
    end
  end
end
