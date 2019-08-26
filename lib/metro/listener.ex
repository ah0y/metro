defmodule Metro.PubSub.Listener do
  use GenServer

  require Logger

  import Jason, only: [decode!: 1]
  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query

  @topic inspect(__MODULE__)


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

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Metro.PubSub, "notifications:" <> "#{user_id}")
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
            "library_id" => library,
            "isbn_id" => isbn,
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
                            %Metro.Notification.Alert{
                              notification_object_id: object.id,
                              notifier_id: user,
                              description: "#{isbn} is in transit to #{library}"
                            }
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                        Metro.Repo.update(
                          from(
                            u in Metro.Account.User,
                            where: u.id == ^user,
                            update: [
                              inc: [
                                pending_notifications: 1
                              ]
                            ]
                          )
                        )
                        end
                      )
                   |> Metro.Repo.transaction()
                   |> case do
                        {:ok, %{object: _, alert: _, user: updated_user}} ->
                          Phoenix.PubSub.broadcast(
                            Metro.PubSub,
                            "notifications:#{user}",
                            {
                              __MODULE__,
                              "new_notification",
                              %{
                                notification: "#{
                                  isbn
                                } is in transit to #{library}",
                                to: user,
                                pending:
                                  updated_user.pending_notifications
                              }
                            }
                          )
                      end
    {:ok, %{notification: "Checkout created and in transit"}}
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
            "isbn_id" => isbn,
            "library_id" => library,
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
                            %Metro.Notification.Alert{
                              notification_object_id: object.id,
                              notifier_id: user,
                              description: "#{isbn} is now in transit to library: #{library}"
                            }
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Repo.update(
                            from(
                              u in Metro.Account.User,
                              where: u.id == ^user,
                              update: [
                                inc: [
                                  pending_notifications: 1
                                ]
                              ]
                            )
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
                   |> case do
                        {:ok, %{object: _, alert: _, user: updated_user}} ->
                          Phoenix.PubSub.broadcast(
                            Metro.PubSub,
                            "notifications:#{user}",
                            {
                              __MODULE__,
                              "new_notification",
                              %{
                                notification: "#{isbn} is now in transit to library: #{library}",
                                to: user,
                                pending:
                                  updated_user.pending_notifications
                              }
                            }
                          )
                      end
    {:ok, %{notification: "Book is now in transit"}}
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
            "isbn_id" => isbn,
            "library_id" => library,
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
                            %Metro.Notification.Alert{
                              notification_object_id: object.id,
                              notifier_id: user,
                              description: "#{isbn} is now ready for pickup at library: #{library}"
                            }
                          )
                        end
                      )
                   |> Ecto.Multi.run(
                        :user,
                        fn _, _ ->
                          Metro.Repo.update(
                            from(
                              u in Metro.Account.User,
                              where: u.id == ^user,
                              update: [
                                inc: [
                                  pending_notifications: 1
                                ]
                              ]
                            )
                          )
                        end
                      )
                   |> Metro.Repo.transaction()
                   |> case do
                        {:ok, %{object: _, alert: _, user: updated_user}} ->
                          Phoenix.PubSub.broadcast(
                            Metro.PubSub,
                            "notifications:#{user}",
                            {
                              __MODULE__,
                              "new_notification",
                              %{
                                notification: "#{
                                  isbn
                                } is now ready for pickup at library: #{
                                  library
                                }",
                                to: user,
                                pending:
                                  updated_user.pending_notifications
                              }
                            }
                          )
                      end
    {:ok, %{notification: "Book is now ready for pickup"}}
  end

  def handle_changes(payload), do: nil
end