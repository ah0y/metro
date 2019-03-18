defmodule Metro.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :pin, :integer

      timestamps()
    end
  end
end
