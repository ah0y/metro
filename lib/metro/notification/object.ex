defmodule Metro.Notification.Object do
  use Ecto.Schema
  import Ecto.Changeset

  alias Metro.Notification.Alert
  alias Metro.Notification.Change

  schema "notification_objects" do
    field :entity_id, :integer
    field :entity_type_id, :integer

    has_many :notification_alerts, Alert #a notification can go to many
    has_one :notification_change, Change #actor of a notification can only belong to one notification

    timestamps()
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:entity_id, :entity_type_id])
    |> validate_required([:entity_id, :entity_type_id])
  end
  @doc """
  Entity type id, Entity, Notification
  1. Checkout, Created and in transit
  2. Checkout, Created and on waitlist
  3. Checkout, Updated and in transit
  4. Reservation, Updated and on reserve

  Entity id is a fk to either checkouts or reservations
  """
end


