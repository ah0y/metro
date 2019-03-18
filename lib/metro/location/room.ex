defmodule Metro.Location.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Event
  alias Metro.Location.Library


  schema "rooms" do
    field :capacity, :integer
#    field :library_id, :id

    belongs_to :library, Library
    has_many :events, Event

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:capacity])
    |> validate_required([:capacity])
  end
end
