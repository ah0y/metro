defmodule Metro.Account.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Account.User


  schema "cards" do
    field :pin, :string

    belongs_to :user, User, foreign_key: :user_id

    has_many :checkouts, Metro.Order.Checkout

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:pin, :user_id])
    |> validate_card_pin_length
    |> validate_required([:pin, :user_id])
  end

  defp validate_card_pin_length(changeset) do
    pin = get_field(changeset, :pin)
    validate_card_pin_length(changeset, pin)
  end

  defp validate_card_pin_length(changeset, pin) do
    if pin == nil or String.length(pin) != 4 do
      add_error(changeset, :pin, "should be 4 digits")
      else
      changeset
    end
  end
end
