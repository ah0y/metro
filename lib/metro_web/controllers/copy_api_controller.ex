defmodule MetroWeb.CopyApiController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Copy
  alias Metro.Order.Checkout

  import Ecto.Query

  #  plug :authorize_resource, model: Book, id_name: "isbn", id_field: "isbn"
  #  use MetroWeb.ControllerAuthorization


  def show(conn, %{"id" => id}) do
    copy = Location.get_copy!(id)
    render(conn, "show.json", copy: copy)
  end
end
