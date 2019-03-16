defmodule Metro.Location.Book do
  use Ecto.Schema
  import Ecto.Changeset


  schema "books" do
    field :image, :string
    field :isbn, :integer
    field :pages, :integer
    field :summary, :string
    field :year, :integer
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:isbn, :year, :summary, :pages, :image])
    |> validate_required([:isbn, :year, :summary, :pages, :image])
  end
end
