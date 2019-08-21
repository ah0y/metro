defmodule Metro.Notification.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Notification.Object

  schema "notification_alerts" do
#    field :notification_object_id, :id
#    field :notifier_id, :id

    belongs_to :notification_object, Object, foreign_key: :notification_object_id
    belongs_to :user, Metro.Account.User, foreign_key: :notifier_id

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:notification_object_id, :notifier_id])
    |> validate_required([:notification_object_id, :notifier_id])
  end

  def list_notifications() do
    [%{description: "Notification!"}]
  end
end
