defmodule Metro.Location.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Author
  alias Metro.Location.Copy
  alias Metro.Location.Genre
  alias Metro.Location

  @primary_key {:isbn, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :isbn}
  schema "books" do
    field :image, :string
    field :title, :string
    field :pages, :integer
    field :summary, :string
    field :year, :integer

    belongs_to :author, Author, foreign_key: :author_id

    has_many :copies, Copy, foreign_key: :isbn_id
    has_many :checkouts, Metro.Order.Checkout

    many_to_many(
      :genres,
      Genre,
      join_through: "book_genres",
      join_keys: [book_id: :isbn, genre_id: :id],
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  @required_fields [:isbn, :title, :year, :summary, :pages, :image, :author_id]
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:isbn, :title, :year, :summary, :pages, :image, :author_id])
    |> unique_constraint(:isbn, name: :books_pkey)
    |> foreign_key_constraint(:author_id)
    |> validate_required(@required_fields)
  end

#  def changeset_update_genres(%Book{} = book, genres) do
#    book
#    |> cast(%{}, @required_fields)
#    |> put_assoc(:genres, genres)
#  end
#
#  def upsert_book_genres(user, genre_ids) when is_list(genre_ids) do
#    genres =
#      Genre
#      |> where([genre], genre.id in ^genre_ids)
#      |> Repo.all()
#
#    with {:ok, _struct} <-
#           book
#           |> Book.changeset_update_genres(genres)
#           |> Repo.update() do
#      {:ok, Location.get_book!(book.isbn)}
#    else
#      error ->
#        error
#    end
#  end
end
