defmodule Metro.Location.Genre do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Book

  schema "genres" do
    field :category, :string

    many_to_many(
      :books,
      Book,
      join_through: "book_genres",
      join_keys: [genre_id: :id, book_id: :isbn_id],
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:category])
    |> validate_required([:category])
  end
end
