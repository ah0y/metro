defmodule Metro.Location.Copy do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Book
  alias Metro.Location.Library


  schema "copies" do
    field :checked_out?, :boolean, default: false

    belongs_to :book, Book, foreign_key: :isbn, references: :isbn, define_field: false
    belongs_to :library, Library, foreign_key: :library_id

    has_many :checkouts, Metro.Order.Checkout
    has_many :transit, Metro.Order.Transit
    has_many :waitlists, Metro.Order.Waitlist

    timestamps()
  end

  @doc false
  def changeset(copy, attrs) do
    copy
    |> cast(attrs, [:checked_out?])
    |> validate_required([:checked_out?])
  end
end
