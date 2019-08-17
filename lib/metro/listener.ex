defmodule Metro.PubSub.Listener do
  use GenServer

  require Logger

  import Jason, only: [decode!: 1]
  import Ecto.Changeset, only: [change: 2]


  @doc """
  Initialize the GenServer
  """
  @spec start_link([String.t], [any]) :: {:ok, pid}
  def start_link(channel, otp_opts \\ []), do: GenServer.start_link(__MODULE__, channel, otp_opts)

  @doc """
  When the GenServer starts subscribe to the given channel
  """
  @spec init([String.t]) :: {:ok, []}
  def init(channel) do
    Logger.debug("Starting #{ __MODULE__ } with channel subscription: #{channel}")
    pg_config = Metro.Repo.config()
    {:ok, pid} = Postgrex.Notifications.start_link(pg_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, channel)
    {:ok, {pid, channel, ref}}
  end

  @doc """
  Listen for changes
  """
  def handle_info({:notification, _pid, _ref, "user_notification", payload}, _state) do
    payload
    |> decode!()
    |> handle_changes()

    {:noreply, :event_handled}
  end

  def handle_info(_, _state), do: {:noreply, :event_received}

  @doc """
  Listen for new users and log when created
  """
  def handle_changes(
        %{
          "type" => "INSERT",
          "table" => "checkouts",
          "new_row_data" => %{
            "id" => checkout,
            "user_id" => user,
            "copy_id" => copy,
            "checkout_date" => checkout_date
          }
        }
      ) when copy != nil and checkout_date == nil do
    IO.puts("Checkout created and in transit")

    notification = Ecto.Multi.new
                   |> Ecto.Multi.run(
                        :object,
                        fn _, _ -> Metro.Repo.insert(%Metro.Notification.Object{entity_id: 1, entity_type_id: checkout})
                        end
                      )
                   |> Ecto.Multi.run(
                        :alert,
                        fn _, %{object: object} ->
                          Metro.Repo.insert(
                            %Metro.Notification.Alert{notification_object_id: object.id, notifier_id: user}
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Account.update_user(
                            Metro.Account.get_user!(user),
                            %{pending_notifications: Metro.Account.get_user!(user).pending_notifications + 1}
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
  end


  @doc """
  Listen for new users and log when created
  """
  def handle_changes(
        %{
          "table" => "checkouts",
          "type" => "INSERT",
          "new_row_data" => %{
            "id" => checkout,
            "user_id" => user,
            "copy_id" => copy,
            "checkout_date" => checkout_date
          }
        }
      ) when copy == nil and checkout_date == nil do
    IO.puts("Checkout created and user on waitlist")

    notification = Ecto.Multi.new
                   |> Ecto.Multi.run(
                        :object,
                        fn _, _ -> Metro.Repo.insert(%Metro.Notification.Object{entity_id: 2, entity_type_id: checkout})
                        end
                      )
                   |> Ecto.Multi.run(
                        :alert,
                        fn _, %{object: object} ->
                          Metro.Repo.insert(
                            %Metro.Notification.Alert{notification_object_id: object.id, notifier_id: user}
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Account.update_user(
                            Metro.Account.get_user!(user),
                            %{pending_notifications: Metro.Account.get_user!(user).pending_notifications + 1}
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
  end

  @doc """
  Listen and log when users change their payment plan
  """
  def handle_changes(
        %{
          "table" => "checkouts",
          "id" => id,
          "type" => "UPDATE",
          "old_row_data" => %{
            "copy_id" => old_copy,
          },
          "new_row_data" => %{
            "id" => checkout,
            "user_id" => user,
            "copy_id" => new_copy,
          },
        }
      ) when old_copy != new_copy do
    IO.puts("Book is now in transit")

    notification = Ecto.Multi.new
                   |> Ecto.Multi.run(
                        :object,
                        fn _, _ -> Metro.Repo.insert(%Metro.Notification.Object{entity_id: 3, entity_type_id: checkout})
                        end
                      )
                   |> Ecto.Multi.run(
                        :alert,
                        fn _, %{object: object} ->
                          Metro.Repo.insert(
                            %Metro.Notification.Alert{notification_object_id: object.id, notifier_id: user}
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Account.update_user(
                            Metro.Account.get_user!(user),
                            %{pending_notifications: Metro.Account.get_user!(user).pending_notifications + 1}
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
  end

  @doc """
  Listen and log when users change their payment plan
  """
  def handle_changes(
        %{
          "table" => "reservations",
          "type" => "UPDATE",
          "old_row_data" => %{
            "expiration_date" => old_expiration,
          },
          "new_row_data" => %{
            "id" => reservation,
            "user_id" => user,
            "expiration_date" => new_expiration,
          },
        }
      ) when old_expiration != new_expiration do
    IO.puts("Book is now ready for pickup")

    notification = Ecto.Multi.new
                   |> Ecto.Multi.run(
                        :object,
                        fn _, _ ->
                          Metro.Repo.insert(%Metro.Notification.Object{entity_id: 4, entity_type_id: reservation})
                        end
                      )
                   |> Ecto.Multi.run(
                        :alert,
                        fn _, %{object: object} ->
                          Metro.Repo.insert(
                            %Metro.Notification.Alert{notification_object_id: object.id, notifier_id: user}
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Account.update_user(
                            Metro.Account.get_user!(user),
                            %{pending_notifications: Metro.Account.get_user!(user).pending_notifications + 1}
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
  end

  def handle_changes(payload), do: nil
end