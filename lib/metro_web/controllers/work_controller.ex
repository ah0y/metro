defmodule MetroWeb.WorkController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Copy
  alias Metro.Order.Checkout
  alias Metro.Location.Book
  alias Metro.Order.Transit

  import Ecto.Query

  plug :authorize_resource, model: Copy
  use MetroWeb.ControllerAuthorization

  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "library" => library
          }
        } = params
      ) do

    query_params = from c in Copy,
                        join: ch in Checkout,
                        join: b in Book,
                        join: t in Transit,
                        where: is_nil(t.actual_arrival),
                        where: t.checkout_id == ch.id,
                        where: c.isbn_id == b.isbn,
                        where: ch.copy_id == c.id,
                        where: c.library_id == ^library,
                        order_by: [
                          desc: ch.inserted_at
                        ],
                        select: %{
                          id: c.id,
                          title: b.title,
                          checked_out?: c.checked_out?,
                          library_id: c.library_id,
                          isbn_id: c.isbn_id,
                          destination: ch.library_id,
                          checkout_date: ch.inserted_at
                        }

    page = Metro.Repo.paginate(query_params)
    libraries = Location.load_libraries()
    render conn, "index.html", copies: page.entries, libraries: libraries, page: page
  end


  def index(conn, params = %{}) do
    query_params = from c in Copy,
                        join: ch in Checkout,
                        join: b in Book,
                        join: t in Transit,
                        where: is_nil(t.actual_arrival),
                        where: c.isbn_id == b.isbn,
                        where: ch.copy_id == c.id,
                        where: c.library_id == 1,
                        order_by: [
                          desc: ch.inserted_at
                        ],
                        select: %{
                          id: c.id,
                          title: b.title,
                          checked_out?: c.checked_out?,
                          library_id: c.library_id,
                          isbn_id: c.isbn_id,
                          destination: ch.library_id,
                          checkout_date: ch.inserted_at
                        }

    page = Metro.Repo.paginate(query_params)
    libraries = Location.load_libraries()
    render(conn, "index.html", copies: page.entries, libraries: libraries, page: page)
  end
end
