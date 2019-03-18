defmodule Metro.Location.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Library


  schema "rooms" do
    field :capacity, :integer

    belongs_to :library, Library, foreign_key: :library_id

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:capacity])
    |> validate_required([:capacity])
  end
end
