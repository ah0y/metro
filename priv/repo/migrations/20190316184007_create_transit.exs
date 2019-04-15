defmodule Metro.Repo.Migrations.CreateTransit do
  use Ecto.Migration

  def change do
    create table(:transit) do
      add :estimated_arrival, :naive_datetime
      add :actual_arrival, :naive_datetime
#      add :copy_id, references(:copies, on_delete: :nothing)
      add :checkout_id, references(:checkouts, on_delete: :nothing)

      timestamps()
    end
    create index(:transit, [:checkout_id])
  end
end
