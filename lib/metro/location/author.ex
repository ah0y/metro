defmodule Metro.Location.Author do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Book


  schema "authors" do
    field :bio, :string
    field :first_name, :string
    field :last_name, :string
    field :location, :string
    field :name, :string, virtual: true

    has_many :books, Book

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :last_name, :location, :bio])
    |> validate_required([:first_name, :last_name])
  end

#  def alphabetical(query) do
#    from a in query, order_by: [a.last_name, a.first_name]
#  end

  def names_and_ids(query) do
    from a in query, select: %{name: fragment("concat(?, ', ', ?)", a.last_name, a.first_name), id: a.id}
  end
end
