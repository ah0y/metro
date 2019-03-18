defmodule Metro.Order.Transit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Checkout

  schema "transit" do
    field :actual_arrival, :naive_datetime
    field :estimated_arrival, :naive_datetime

    belongs_to :copies, Metro.Location.Copy, foreign_key: :copy_id
    belongs_to :checkouts, Checkout, foreign_key: :checkout_id

    timestamps()
  end

  @doc false
  def changeset(transit, attrs) do
    transit
    |> cast(attrs, [:estimated_arrival, :actual_arrival])
    |> validate_required([:estimated_arrival, :actual_arrival])
  end
end
