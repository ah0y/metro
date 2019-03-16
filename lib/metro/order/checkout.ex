defmodule Metro.Order.Checkout do
  use Ecto.Schema
  import Ecto.Changeset


  schema "checkouts" do
    field :checkout_date, :naive_datetime
    field :due_date, :naive_datetime
    field :renewals_remaining, :integer
    field :card_id, :id
    field :bookintsance_id, :id
    field :library_id, :id

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:renewals_remaining, :checkout_date, :due_date])
    |> validate_required([:renewals_remaining, :checkout_date, :due_date])
  end
end
