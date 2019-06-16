defmodule MetroWeb.BookApiController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Author
  alias Metro.Location.Book

  import Ecto.Query

#  plug :authorize_resource, model: Book, id_name: "isbn", id_field: "isbn"
#  use MetroWeb.ControllerAuthorization


  def index(conn, _params) do

    books = Location.list_books

    render conn, "index.json", books: books
  end

  def show(conn, %{"isbn" => isbn}) do
    book = Location.get_book_and_copies(isbn)
    render(conn, "show.json", book: book)
  end
end
