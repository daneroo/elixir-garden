#---
# Excerpted from "Machine Learning in Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/smelixir for more book information.
#---
defmodule BookSearch.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :description, :string
    field :embedding, Pgvector.Ecto.Vector
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:author, :title, :description, :embedding])
    |> validate_required([:author, :title, :description])
  end

  @doc false
  def put_embedding(%{changes: %{description: desc}} = book_changeset) do
    embedding = BookSearch.Model.predict(desc)
    put_change(book_changeset, :embedding, embedding)
  end
end
