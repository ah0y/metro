defmodule Metro.Account.User do
  @moduledoc false
  use Ecto.Schema
  use Coherence.Schema

  alias Metro.Account.Card

  schema "users" do
    field :name, :string
    field :email, :string

    field :fines, :float
    field :is_librarian?, :boolean, default: false
    field :num_books_out, :integer

    has_one :card, Card
    belongs_to :library, Metro.Location.Library, foreign_key: :library_id

    has_many :checkouts, through: [:card, :checkouts]
    has_many :books, through: [:checkouts, :book]

    coherence_schema()


    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :fines, :is_librarian?, :num_books_out, :library_id] ++ coherence_fields())
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
  end
end
