defmodule Metro.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :renewals_remaining, :integer
      add :checkout_date, :naive_datetime
      add :due_date, :naive_datetime
      add :card_id, references(:cards, on_delete: :nothing)
      add :bookintsance_id, references(:copies, on_delete: :nothing)
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end

    create index(:checkouts, [:card_id])
    create index(:checkouts, [:bookintsance_id])
    create index(:checkouts, [:library_id])
  end
end
