defmodule MetroWeb.CopyController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Copy
  alias Metro.Order.Checkout

  import Ecto.Query

  plug :authorize_resource, model: Copy
  use MetroWeb.ControllerAuthorization

  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    query_params = from c in Copy, where: field(c, ^search_by) == ^query

    page = Metro.Repo.paginate(query_params, page: pagenumber)

    render conn, "index.html", copies: page.entries, page: page
  end

  def index(conn, params = %{}) do
    query_params = from c in Copy
    pagenumber = conn.params["page"] || 1
    page = Metro.Repo.paginate(query_params, page: pagenumber)

    render conn, "index.html", copies: page.entries, page: page
  end

  def new(conn, %{"isbn" => isbn}) do
    libraries = Location.load_libraries()
    changeset = Location.change_copy(%Copy{})
    render(conn, "new.html", changeset: changeset, libraries: libraries, isbn: isbn)
  end

  def new(conn, _params) do
    libraries = Location.load_libraries()
    changeset = Location.change_copy(%Copy{})
    render(conn, "new.html", changeset: changeset, libraries: libraries)
  end

  def create(conn, %{"copy" => copy_params}) do
    case Location.create_copy(copy_params) do
      {:ok, copy} ->
        conn
        |> put_flash(:info, "Copy created successfully.")
        |> redirect(to: Routes.copy_path(conn, :show, copy))
      {:error, %Ecto.Changeset{} = changeset} ->
        libraries = Location.load_libraries()
        render(conn, "new.html", libraries: libraries, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    copy = Location.get_copy!(id)
    render(conn, "show.html", copy: copy)
  end

  def edit(conn, %{"id" => id}) do
    libraries = Location.load_libraries()
    copy = Location.get_copy!(id)
    changeset = Location.change_copy(copy)
    render(conn, "edit.html", copy: copy, changeset: changeset, libraries: libraries)
  end

  def update(conn, %{"id" => id, "copy" => copy_params}) do
    libraries = Location.load_libraries()
    copy = Location.get_copy!(id)
    case Location.update_copy(copy, copy_params) do
      {:ok, copy} ->
        conn
        |> put_flash(:info, "Copy updated successfully.")
        |> redirect(to: Routes.copy_path(conn, :show, copy))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", copy: copy, changeset: changeset, libraries: libraries)
    end
  end

  def delete(conn, %{"id" => id}) do
    copy = Location.get_copy!(id)
    {:ok, _copy} = Location.delete_copy(copy)

    conn
    |> put_flash(:info, "Copy deleted successfully.")
    |> redirect(to: Routes.copy_path(conn, :index))
  end
end
