defmodule MetroWeb.WaitlistController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Waitlist

  import Ecto.Query

  plug :authorize_resource, model: Waitlist
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

    query_params = from w in Waitlist, where: field(w, ^search_by) == ^query

    page = Metro.Repo.paginate(query_params, page: pagenumber)

    render conn, "index.html", waitlists: page.entries, page: page
  end

  def index(conn, params = %{}) do
    query_params = from w in Waitlist
    pagenumber = conn.params["page"]
    page = Metro.Repo.paginate(params, page: pagenumber)
    render conn, "index.html", waitlists: page.entries, page: page
  end

  def new(conn, _params) do
    changeset = Order.change_waitlist(%Waitlist{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"waitlist" => waitlist_params}) do
    case Order.create_waitlist(waitlist_params) do
      {:ok, waitlist} ->
        conn
        |> put_flash(:info, "Waitlist created successfully.")
        |> redirect(to: Routes.waitlist_path(conn, :show, waitlist))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    waitlist = Order.get_waitlist!(id)
    render(conn, "show.html", waitlist: waitlist)
  end

  def edit(conn, %{"id" => id}) do
    waitlist = Order.get_waitlist!(id)
    changeset = Order.change_waitlist(waitlist)
    render(conn, "edit.html", waitlist: waitlist, changeset: changeset)
  end

  def update(conn, %{"id" => id, "waitlist" => waitlist_params}) do
    waitlist = Order.get_waitlist!(id)

    case Order.update_waitlist(waitlist, waitlist_params) do
      {:ok, waitlist} ->
        conn
        |> put_flash(:info, "Waitlist updated successfully.")
        |> redirect(to: Routes.waitlist_path(conn, :show, waitlist))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", waitlist: waitlist, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    waitlist = Order.get_waitlist!(id)
    {:ok, _waitlist} = Order.delete_waitlist(waitlist)

    conn
    |> put_flash(:info, "Waitlist deleted successfully.")
    |> redirect(to: Routes.waitlist_path(conn, :index))
  end
end
