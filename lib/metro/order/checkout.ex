defmodule Metro.Order.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Transit
  alias Metro.Order.Waitlist

  schema "checkouts" do
    field :checkout_date, :naive_datetime
    field :checkin_date, :naive_datetime
    field :due_date, :naive_datetime
    field :renewals_remaining, :integer, default: 3

    belongs_to :book, Metro.Location.Book, foreign_key: :isbn_id, references: :isbn
    belongs_to :card, Metro.Account.Card, foreign_key: :card_id
    belongs_to :library, Metro.Location.Library, foreign_key: :library_id
    belongs_to :copy, Metro.Location.Copy, foreign_key: :copy_id


    has_one :transit, Transit
    has_many :waitlists, Waitlist

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:isbn_id, :card_id, :library_id, :copy_id, :checkout_date,:checkin_date, :due_date, :renewals_remaining ])
    |> validate_required([:renewals_remaining, :isbn_id, :card_id, :library_id])
  end
end
