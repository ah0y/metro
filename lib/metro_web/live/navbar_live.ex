defmodule MetroWeb.NavbarLive do
  use Phoenix.LiveView

  alias Metro.Notification.Alert
  alias MetroWeb.SharedView


  def render(%{current_user: user} = assigns) when user != nil do
    SharedView.render(
      "navbar_authenticated.html",
      assigns
    )
  end

  def render(assigns) do
    SharedView.render("navbar.html", assigns)
  end


  def mount(%{user_id: user_id} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn -> Metro.Account.get_user!(user_id) end)
    {:ok, fetch(socket)}
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