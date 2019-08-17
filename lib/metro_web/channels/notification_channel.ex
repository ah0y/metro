defmodule MetroWeb.NotificationChannel  do
  use Phoenix.Channel

  def join("notifications:" <> user_id, _payload, socket) do
#    require IEx; IEx.pry()
    {:ok, "Joined Notification:#{user_id}", socket}
  end

  def handle_in("new_notification", %{"body" => body}, socket) do
    broadcast! socket, "new_notification", %{body: body}
    {:noreply, socket}
  end
end

