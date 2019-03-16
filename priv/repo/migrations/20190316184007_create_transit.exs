defmodule Metro.Repo.Migrations.CreateTransit do
  use Ecto.Migration

  def change do
    create table(:transit) do
      add :estimated_arrival, :naive_datetime
      add :actual_arrival, :naive_datetime
      add :library_id, references(:libraries, on_delete: :nothing)
      add :copy_id, references(:copies, on_delete: :nothing)
      add :checkout_id, references(:checkouts, on_delete: :nothing)

      timestamps()
    end

    create index(:transit, [:library_id])
    create index(:transit, [:copy_id])
    create index(:transit, [:checkout_id])
  end
end
