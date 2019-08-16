defmodule Metro.Repo.Migrations.CreateNotificationObjects do
  use Ecto.Migration

  def change do
    create table(:notification_objects) do
      add :entity_id, :integer
      add :entity_type_id, :integer

      timestamps()
    end

  end
end
