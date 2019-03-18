defmodule Metro.Location.Library do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Room
  alias Metro.Location.Copy


  schema "libraries" do
    field :address, :string
    field :hours, :string
    field :image, :string
    field :branch, :string

    has_many :rooms, Room
    has_many :copies, Copy

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:branch, :address, :image, :hours])
    |> validate_required([:branch, :address, :image, :hours])
  end
end
