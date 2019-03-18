defmodule Metro.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :description, :text
      add :images, :string
      add :datetime, :naive_datetime

      timestamps()
    end

  end
end
