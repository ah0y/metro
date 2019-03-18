defmodule Metro.Order.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Transit

  schema "checkouts" do
    field :checkout_date, :naive_datetime
    field :due_date, :naive_datetime
    field :renewals_remaining, :integer

    belongs_to :card, Metro.Location.Card, foreign_key: :card_id
    belongs_to :library, Metro.Location.Library, foreign_key: :library_id
#    belongs_to :copy, Metro.Location.Copy, foreign_key: :copy_id

    has_one :transit, Transit

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:renewals_remaining, :checkout_date, :due_date])
    |> validate_required([:renewals_remaining, :checkout_date, :due_date])
  end
end
