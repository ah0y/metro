defmodule MetroWeb.NotificationView do
  use MetroWeb, :view

  def render("notification.json", %{notification: notif}) do
    %{
      description: notif.description,
    }
  end
end
