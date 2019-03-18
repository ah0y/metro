defmodule Metro.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :capacity, :integer
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end
    create index(:rooms, [:library_id])
  end
end
