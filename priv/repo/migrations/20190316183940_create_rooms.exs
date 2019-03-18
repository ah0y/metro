defmodule Metro.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :capacity, :integer

      timestamps()
    end

  end
end
