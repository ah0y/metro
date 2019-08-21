defmodule MetroWeb.NavbarLive do
  use Phoenix.LiveView

  alias Metro.Notification.Alert
  alias MetroWeb.SharedView


  def render(%{current_user: user} = assigns) do
#    require IEx; IEx.pry()
    SharedView.render("navbar_authenticated.html", assigns)
  end

  def render(assigns) do
    SharedView.render("navbar.html", assigns)
  end


  def mount(session, socket) do
    {:ok, fetch(assign(socket, current_user: session.current_user))}
  end

#  def handle_info(%Phoenix.Socket.Broadcast{event: "notifications:1"}, socket) do
#    IO.puts "ding"
#    {:noreply, fetch(socket)}
#  end

  defp fetch(socket) do
    assign(socket, notifications: Alert.list_notifications())
#    require IEx; IEx.pry()
  end
end