defmodule Metro.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :expiration_date, :naive_datetime
      add :card_id, references(:cards, on_delete: :nothing)
      add :copy_id, references(:copies, on_delete: :nothing)
      add :library_id, references(:libraries, on_delete: :nothing)
      add :transit_id, references(:transit, on_delete: :nothing)

      timestamps()
    end

    create index(:reservations, [:card_id])
    create index(:reservations, [:copy_id])
    create index(:reservations, [:library_id])
    create index(:reservations, [:transit_id])
  end
end
