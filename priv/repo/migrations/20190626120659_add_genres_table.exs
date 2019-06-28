defmodule Metro.Repo.Migrations.AddGenresTable do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :category, :string

      timestamps()
    end
  end
end
