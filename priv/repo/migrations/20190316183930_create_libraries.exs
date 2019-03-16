defmodule Metro.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :address, :string
      add :image, :string
      add :hours, :string

      timestamps()
    end

  end
end
