defmodule Metro.Repo.Migrations.CreateNotificationChanges do
  use Ecto.Migration

  def change do
    create table(:notification_changes) do
      add :notification_object_id, references(:notification_objects, on_delete: :nothing)
      add :actor_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:notification_changes, [:notification_object_id])
    create index(:notification_changes, [:actor_id])
  end
end
