defmodule MetroWeb.ReservationController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Reservation

  def index(conn, _params) do
    reservations = Order.list_reservations()
    render(conn, "index.html", reservations: reservations)
  end

  def new(conn, _params) do
    changeset = Order.change_reservation(%Reservation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reservation" => reservation_params}) do
    case Order.create_reservation(reservation_params) do
      {:ok, reservation} ->
        conn
        |> put_flash(:info, "Reservation created successfully.")
        |> redirect(to: Routes.reservation_path(conn, :show, reservation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reservation = Order.get_reservation!(id)
    render(conn, "show.html", reservation: reservation)
  end

  def edit(conn, %{"id" => id}) do
    reservation = Order.get_reservation!(id)
    changeset = Order.change_reservation(reservation)
    render(conn, "edit.html", reservation: reservation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reservation" => reservation_params}) do
    reservation = Order.get_reservation!(id)

    case Order.update_reservation(reservation, reservation_params) do
      {:ok, reservation} ->
        conn
        |> put_flash(:info, "Reservation updated successfully.")
        |> redirect(to: Routes.reservation_path(conn, :show, reservation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reservation: reservation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reservation = Order.get_reservation!(id)
    {:ok, _reservation} = Order.delete_reservation(reservation)

    conn
    |> put_flash(:info, "Reservation deleted successfully.")
    |> redirect(to: Routes.reservation_path(conn, :index))
  end
end
