defmodule Metro.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :description, :text
      add :images, :string
      add :datetime, :naive_datetime
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end
    create index(:events, [:room_id])
  end
end
