defmodule Metro.Location.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Library
  alias Metro.Location.Room


  schema "events" do
    field :datetime, :naive_datetime
    field :description, :string
    field :images, :string
#    field :library_id, :id
#    field :room_id, :id

    belongs_to :room, Room
    belongs_to :library, Library

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:description, :images, :datetime])
    |> validate_required([:description, :images, :datetime])
  end
end
