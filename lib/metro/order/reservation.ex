defmodule Metro.Order.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Transit

  schema "reservations" do
    field :expiration_date, :naive_datetime

    belongs_to :transit, Transit, foreign_key: :transit_id

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:expiration_date, :transit_id])
    |> validate_required([:expiration_date, :transit_id])
  end
end
