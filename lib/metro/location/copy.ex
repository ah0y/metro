defmodule Metro.Location.Copy do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Location.Book
  alias Metro.Location.Library


  schema "copies" do
    field :checked_out?, :boolean, default: false

    belongs_to :book, Book, foreign_key: :isbn_id, references: :isbn
    belongs_to :library, Library, foreign_key: :library_id

    has_many :checkouts, Metro.Order.Checkout
    has_many :transit, Metro.Order.Transit
    has_many :waitlists, Metro.Order.Waitlist

    timestamps()
  end

  @doc false
  def changeset(copy, attrs) do
    copy
    |> cast(attrs, [:checked_out?, :library_id, :isbn_id])
    |> foreign_key_constraint(:library_id)
    |> foreign_key_constraint(:isbn_id)
    |> validate_required([:checked_out?, :library_id, :isbn_id])
  end
end
