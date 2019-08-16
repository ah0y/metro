defmodule Metro.Order.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Transit

  schema "reservations" do
    field :expiration_date, :naive_datetime

    belongs_to :user, Metro.Account.User, foreign_key: :user_id
    belongs_to :transit, Transit, foreign_key: :transit_id

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:user_id, :expiration_date, :transit_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:transit_id)
    |> validate_required([:transit_id])
  end
end
