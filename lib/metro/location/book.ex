defmodule Metro.Location.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Author
  alias Metro.Location.Copy

  @primary_key {:isbn, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :isbn}
  schema "books" do
    field :image, :string
    field :title, :string
    field :pages, :integer
    field :summary, :string
    field :year, :integer

    belongs_to :author, Author, foreign_key: :author_id

    has_many :copies, Copy

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:isbn, :title, :year, :summary, :pages, :image])
    |> unique_constraint(:isbn, name: :books_pkey )
    |> validate_required([:isbn, :title, :year, :summary, :pages, :image])
  end
end
