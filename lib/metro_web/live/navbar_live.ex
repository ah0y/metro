defmodule MetroWeb.NotificationsLive do
  use Phoenix.LiveView

  alias Metro.Notification.Alert
  alias MetroWeb.SharedView

  def render(assigns) do
    SharedView.render("notifications.html", assigns)
  end


  def mount(_session, socket) do
    {:ok, fetch(socket)}
  end

  #  def handle_info(%Phoenix.Socket.Broadcast{event: "notifications:1"}, socket) do
  #    IO.puts "ding"
  #    {:noreply, fetch(socket)}
  #  end

  defp fetch(socket) do
    assign(socket, notifications: Alert.list_notifications())
  end
end