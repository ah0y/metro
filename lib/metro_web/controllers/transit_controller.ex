defmodule MetroWeb.TransitController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Transit

  def index(conn, _params) do
    transit = Order.list_transit()
    render(conn, "index.html", transit: transit)
  end

  def new(conn, _params) do
    changeset = Order.change_transit(%Transit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transit" => transit_params}) do
    case Order.create_transit(transit_params) do
      {:ok, transit} ->
        conn
        |> put_flash(:info, "Transit created successfully.")
        |> redirect(to: transit_path(conn, :show, transit))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transit = Order.get_transit!(id)
    render(conn, "show.html", transit: transit)
  end

  def edit(conn, %{"id" => id}) do
    transit = Order.get_transit!(id)
    changeset = Order.change_transit(transit)
    render(conn, "edit.html", transit: transit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transit" => transit_params}) do
    transit = Order.get_transit!(id)

    case Order.update_transit(transit, transit_params) do
      {:ok, transit} ->
        conn
        |> put_flash(:info, "Transit updated successfully.")
        |> redirect(to: transit_path(conn, :show, transit))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transit: transit, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transit = Order.get_transit!(id)
    {:ok, _transit} = Order.delete_transit(transit)

    conn
    |> put_flash(:info, "Transit deleted successfully.")
    |> redirect(to: transit_path(conn, :index))
  end
end
