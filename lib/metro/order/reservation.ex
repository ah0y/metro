defmodule Metro.Order.Reservation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "reservations" do
    field :expiration_date, :naive_datetime
    field :card_id, :id
    field :copy_id, :id
    field :library_id, :id
    field :transit_id, :id

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:expiration_date])
    |> validate_required([:expiration_date])
  end
end
