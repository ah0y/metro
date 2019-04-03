defmodule Metro.Account.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Account.User


  schema "cards" do
    field :pin, :integer

    belongs_to :user, User, foreign_key: :user_id

    has_many :checkouts, Metro.Order.Checkout

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:pin, :user_id])
    |> validate_required([:pin])
  end
end
