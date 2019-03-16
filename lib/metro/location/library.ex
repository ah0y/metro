defmodule Metro.Location.Library do
  use Ecto.Schema
  import Ecto.Changeset


  schema "libraries" do
    field :address, :string
    field :hours, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:address, :image, :hours])
    |> validate_required([:address, :image, :hours])
  end
end
