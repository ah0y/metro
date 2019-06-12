defmodule Metro.Location.Room do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Library
  alias Metro.Location.Event


  schema "rooms" do
    field :capacity, :integer
    field :room_name, :string, virtual: true

    has_many :events, Event

    belongs_to :library, Library, foreign_key: :library_id

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:capacity, :library_id])
    |> foreign_key_constraint(:library_id)
    |> validate_required([:capacity, :library_id])
  end

  def room_name(query) do
    from r in query,
         join: l in assoc(r, :library),
         select: %{
           room_name: fragment("concat(?, ', ', ?)", l.branch, r.capacity),
           id: r.id
         }
  end
end
