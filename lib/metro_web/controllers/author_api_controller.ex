defmodule MetroWeb.AuthorApiController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Book
  alias Metro.Location.Author

  import Ecto.Query

  #  plug :authorize_resource, model: Book, id_name: "isbn", id_field: "isbn"
  #  use MetroWeb.ControllerAuthorization


  def show(conn, %{"id" => id}) do
    author = Location.get_author_and_books(id)
    render(conn, "show.json", author: author)
  end
end
