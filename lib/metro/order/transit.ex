defmodule Metro.Order.Transit do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transit" do
    field :actual_arrival, :naive_datetime
    field :estimated_arrival, :naive_datetime
    field :library_id, :id
    field :copy_id, :id
    field :checkout_id, :id

    timestamps()
  end

  @doc false
  def changeset(transit, attrs) do
    transit
    |> cast(attrs, [:estimated_arrival, :actual_arrival])
    |> validate_required([:estimated_arrival, :actual_arrival])
  end
end
