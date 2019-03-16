defmodule Metro.Order.Waitlist do
  use Ecto.Schema
  import Ecto.Changeset


  schema "waitlist" do
    field :position, :integer
    field :card_id, :id
    field :copy_id, :id
    field :checkout_id, :id

    timestamps()
  end

  @doc false
  def changeset(waitlist, attrs) do
    waitlist
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end
end
