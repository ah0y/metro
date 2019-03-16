defmodule Metro.Location.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :capacity, :integer
    field :library_id, :id

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:capacity])
    |> validate_required([:capacity])
  end
end
