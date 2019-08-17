defmodule Metro.Notification.Change do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Notification.Object

  schema "notification_changes" do
#    field :notification_object_id, :id
#    field :actor_id, :id

    belongs_to :notification_object, Object, foreign_key: :notification_object_id
    belongs_to :user, Metro.Account.User, foreign_key: :actor_id

    timestamps()
  end

  @doc false
  def changeset(change, attrs) do
    change
    |> cast(attrs, [:notification_object_id, :notifier_id])
    |> validate_required([:notification_object_id, :notifier_id])
  end
end
