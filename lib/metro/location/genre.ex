defmodule Metro.Location.Genre do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Book
#  alias Metro.Location.BookGenre

  schema "genres" do
    field :category, :string

    many_to_many(
      :books,
      Book,
      join_through: Metro.Location.BookGenre,
      join_keys: [
        genre_id: :id,
        book_isbn: :isbn
      ],
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
