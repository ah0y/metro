defmodule Metro.Order.Waitlist do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Checkout

  schema "waitlist" do
    field :position, :integer

    belongs_to :copies, Metro.Location.Copy, foreign_key: :copy_id
    belongs_to :checkouts, Checkout, foreign_key: :checkout_id

    timestamps()
  end

  @doc false
  def changeset(waitlist, attrs) do
    waitlist
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end
end
