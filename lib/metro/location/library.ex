defmodule Metro.Location.Library do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Metro.Location.Room
  alias Metro.Location.Copy


  schema "libraries" do
    field :address, :string
    field :hours, :string
    field :image, :string
    field :branch, :string

    has_many :rooms, Room
    has_many :copies, Copy
    has_many :checkouts, Metro.Order.Checkout
    has_many :users, Metro.Account.User

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:branch, :address, :image, :hours])
    |> validate_required([:branch, :address, :image, :hours])
  end

  def branch_and_ids(query) do
    from l in query, select: %{branch: l.branch, id: l.id}
  end
end
