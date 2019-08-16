defmodule Metro.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :expiration_date, :naive_datetime
      add :transit_id, references(:transit, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:reservations, [:transit_id])
    create index(:reservations, [:user_id])
  end
end
