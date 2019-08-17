defmodule Metro.Repo.Migrations.BroadcastCheckoutsTableChanges do
  use Ecto.Migration

  def up do
    # Create a function that broadcasts row changes
    execute "
      CREATE OR REPLACE FUNCTION broadcast_changes()
      RETURNS trigger AS $$
      DECLARE
        current_row RECORD;
      BEGIN
        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
          current_row := NEW;
        ELSE
          current_row := OLD;
        END IF;
        IF (TG_OP = 'INSERT') THEN
          OLD := NEW;
        END IF;
      PERFORM pg_notify(
          'user_notification',
          json_build_object(
            'table', TG_TABLE_NAME,
            'type', TG_OP,
            'id', current_row.id,
            'new_row_data', row_to_json(NEW),
            'old_row_data', row_to_json(OLD)
          )::text
        );
      RETURN current_row;
      END;
      $$ LANGUAGE plpgsql;"

    # Create a trigger links the users table to the broadcast function
    execute "
      CREATE TRIGGER notify_checkouts_changes_trigger
      AFTER INSERT OR UPDATE OR DELETE
      ON checkouts
      FOR EACH ROW
      EXECUTE PROCEDURE broadcast_changes();"
  end

  def down do
    execute "DROP TRIGGER notify_checkouts_changes_trigger"
  end
end
