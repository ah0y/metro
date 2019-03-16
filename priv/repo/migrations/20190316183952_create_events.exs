defmodule Metro.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :description, :string
      add :images, :string
      add :datetime, :naive_datetime
      add :library_id, references(:libraries, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:library_id])
    create index(:events, [:room_id])
  end
end
