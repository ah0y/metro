defmodule MetroWeb.TransitController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Location
  alias Metro.Order.Transit
  alias Metro.Order.Reservation
  alias Metro.Order.Checkout

  import Ecto.Query

  plug :load_and_authorize_resource, model: Transit
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

    query_params = from t in Transit,
                        join: ch in Checkout,
                        where: t.checkout_id == ch.id,
                        where: ch.library_id == ^library,
                        where: is_nil(t.actual_arrival),
                        select: %{
                          id: t.id,
                          checkout_id: ch.id,
                          copy_id: ch.copy_id,
                          destination: ch.library_id,
                          estimated_arrival: t.estimated_arrival,
                          actual_arrival: t.actual_arrival
                        }
    page = Metro.Repo.paginate(query_params)
    libraries = Location.load_libraries()
    render(conn, "index.html", transit: page.entries, libraries: libraries, page: page)
  end

  def index(conn, params = %{}) do
    query_params = from t in Transit,
                        join: ch in Checkout,
                        where: t.checkout_id == ch.id,
                        where: ch.library_id == 1,
                        where: is_nil(t.actual_arrival),
                        select: %{
                          id: t.id,
                          checkout_id: ch.id,
                          copy_id: ch.copy_id,
                          destination: ch.library_id,
                          estimated_arrival: t.estimated_arrival,
                          actual_arrival: t.actual_arrival
                        }
    page =  Metro.Repo.paginate(query_params)
    libraries = Location.load_libraries()
    render conn, "index.html", transit: page.entries, page: page, libraries: libraries
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
        |> redirect(to: Routes.transit_path(conn, :show, transit))
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
        |> redirect(to: Routes.transit_path(conn, :show, transit))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transit: transit, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id}) do
    transit = Order.get_transit!(id)
    reservation = Order.get_reservation_by_transit!(id)

    case Order.complete_transit(transit, reservation) do
      {:ok, %{transit: transit, reservation: reservation}} ->
        conn
        |> put_flash(:info, "Transit completed successfully.")
        |> redirect(to: Routes.transit_path(conn, :index))
      {:error, _} ->
        IO.puts("error")
    end
  end

  def delete(conn, %{"id" => id}) do
    transit = Order.get_transit!(id)
    {:ok, _transit} = Order.delete_transit(transit)

    conn
    |> put_flash(:info, "Transit deleted successfully.")
    |> redirect(to: Routes.transit_path(conn, :index))
  end
end
