defmodule Metro.Account.Card do
  use Ecto.Schema
  import Ecto.Changeset


  schema "cards" do
    field :pin, :integer

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:pin])
    |> validate_required([:pin])
  end
end
