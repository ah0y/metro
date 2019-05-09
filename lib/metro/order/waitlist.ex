defmodule Metro.Order.Waitlist do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Order.Checkout

  schema "waitlist" do
    field :position, :integer

    belongs_to :book, Metro.Location.Book, foreign_key: :isbn_id, references: :isbn
    belongs_to :copies, Metro.Location.Copy, foreign_key: :copy_id
    belongs_to :checkout, Checkout, foreign_key: :checkout_id

    timestamps()
  end

  @doc false
  def changeset(waitlist, attrs) do
    waitlist
    |> cast(attrs, [:position, :copy_id, :checkout_id, :isbn_id])
    |> validate_required([:position, :checkout_id])
  end
end
