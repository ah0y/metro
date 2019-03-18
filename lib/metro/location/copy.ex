defmodule Metro.Location.Copy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "copies" do
    field :checked_out?, :boolean, default: false
    field :library_id, :id
    field :isbn_id, :id

    timestamps()
  end

  @doc false
  def changeset(copy, attrs) do
    copy
    |> cast(attrs, [:checked_out?])
    |> validate_required([:checked_out?])
  end
end
