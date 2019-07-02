defmodule Metro.Location.BookGenre do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Book
  alias Metro.Location.Genre

  @already_exists "ALREADY_EXISTS"
  @primary_key false
  schema "book_genres" do
    belongs_to :books, Book, foreign_key: :book_isbn, references: :isbn
    belongs_to :genres, Genre, foreign_key: :genre_id

    timestamps()
  end

  @doc false
  @required_fields [:book_isbn, :genre_id]
  def changeset(book_genre, attrs) do
    book_genre
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:genre_id)
    |> foreign_key_constraint(:book_isbn)
    |> unique_constraint(
         [:book, :genre],
         name: :book_isbn_genre_id_unique_index,
         message: @already_exists
       )
  end
end
