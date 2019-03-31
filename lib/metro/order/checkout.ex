defmodule Metro.Order.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Transit

  schema "checkouts" do
    field :checkout_date, :naive_datetime
    field :due_date, :naive_datetime
    field :renewals_remaining, :integer

    belongs_to :book, Metro.Location.Book, foreign_key: :isbn_id, references: :isbn
    belongs_to :card, Metro.Account.Card, foreign_key: :card_id
    belongs_to :library, Metro.Location.Library, foreign_key: :library_id
    belongs_to :copy, Metro.Location.Copy, foreign_key: :copy_id


    has_one :transit, Transit

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:isbn_id, :card_id, :library_id, :copy_id])
    |> validate_required([:isbn_id, :card_id, :library_id, :checkout_date, :due_date, :renewals_remaining])
  end
end
