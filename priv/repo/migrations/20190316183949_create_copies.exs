defmodule Metro.Repo.Migrations.CreateCopies do
  use Ecto.Migration

  def change do
    create table(:copies) do
      add :checked_out?, :boolean, default: false, null: false

      timestamps()
    end

  end
end
