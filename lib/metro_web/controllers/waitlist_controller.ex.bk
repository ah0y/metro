defmodule MetroWeb.WaitlistController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Waitlist

  def index(conn, _params) do
    waitlist = Order.list_waitlist()
    render(conn, "index.html", waitlist: waitlist)
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
        |> redirect(to: waitlist_path(conn, :show, waitlist))
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
        |> redirect(to: waitlist_path(conn, :show, waitlist))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", waitlist: waitlist, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    waitlist = Order.get_waitlist!(id)
    {:ok, _waitlist} = Order.delete_waitlist(waitlist)

    conn
    |> put_flash(:info, "Waitlist deleted successfully.")
    |> redirect(to: waitlist_path(conn, :index))
  end
end
