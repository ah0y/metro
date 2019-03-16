defmodule Metro.Location.Author do
  use Ecto.Schema
  import Ecto.Changeset


  schema "authors" do
    field :bio, :string
    field :first_name, :string
    field :last_name, :string
    field :location, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :last_name, :location, :bio])
    |> validate_required([:first_name, :last_name, :location, :bio])
  end
end
