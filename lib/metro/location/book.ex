defmodule Metro.Location.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:isbn, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :isbn}
  schema "books" do
    field :image, :string
    field :title, :string
    field :pages, :integer
    field :summary, :string
    field :year, :integer
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:isbn, :title, :year, :summary, :pages, :image])
    |> validate_required([:isbn, :year, :summary, :pages, :image])
  end
end
