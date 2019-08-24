defmodule MetroWeb.NotificationsLive do
  use Phoenix.LiveView

  alias Metro.Notification.Alert
  alias MetroWeb.SharedView

  def render(assigns) do
    SharedView.render("notifications.html", assigns)
  end


  def mount(session, socket) do
    if connected?(socket) do
      IO.inspect session
      Metro.PubSub.Listener.subscribe(session.current_user)
    end
    {:ok, fetch(socket)}
  end

  def handle_info(
        {Metro.PubSub.Listener, "new_notification", %{body: notification}},
        socket
      ) do
    IO.puts "luck"
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, notifications: Alert.list_notifications())
  end
end