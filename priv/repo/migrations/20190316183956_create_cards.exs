defmodule Metro.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :pin, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:cards, [:user_id])
  end
end
