defmodule Metro.Repo.Migrations.CreateNotificationAlerts do
  use Ecto.Migration

  def change do
    create table(:notification_alerts) do
      add :notification_object_id, references(:notification_objects, on_delete: :nothing)
      add :notifier_id, references(:users, on_delete: :nothing)
      add :description, :string

      timestamps()
    end

    create index(:notification_alerts, [:notification_object_id])
    create index(:notification_alerts, [:notifier_id])
  end
end
