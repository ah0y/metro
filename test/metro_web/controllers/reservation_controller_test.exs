defmodule MetroWeb.ReservationControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Order

  @create_attrs %{expiration_date: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{expiration_date: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{expiration_date: nil}

  def fixture(:reservation) do
    {:ok, reservation} = Order.create_reservation(@create_attrs)
    reservation
  end

  describe "index" do
    test "lists all reservations", %{conn: conn} do
      conn = get conn, reservation_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Reservations"
    end
  end

  describe "new reservation" do
    test "renders form", %{conn: conn} do
      conn = get conn, reservation_path(conn, :new)
      assert html_response(conn, 200) =~ "New Reservation"
    end
  end

  describe "create reservation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, reservation_path(conn, :create), reservation: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == reservation_path(conn, :show, id)

      conn = get conn, reservation_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Reservation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, reservation_path(conn, :create), reservation: @invalid_attrs
      assert html_response(conn, 200) =~ "New Reservation"
    end
  end

  describe "edit reservation" do
    setup [:create_reservation]

    test "renders form for editing chosen reservation", %{conn: conn, reservation: reservation} do
      conn = get conn, reservation_path(conn, :edit, reservation)
      assert html_response(conn, 200) =~ "Edit Reservation"
    end
  end

  describe "update reservation" do
    setup [:create_reservation]

    test "redirects when data is valid", %{conn: conn, reservation: reservation} do
      conn = put conn, reservation_path(conn, :update, reservation), reservation: @update_attrs
      assert redirected_to(conn) == reservation_path(conn, :show, reservation)

      conn = get conn, reservation_path(conn, :show, reservation)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, reservation: reservation} do
      conn = put conn, reservation_path(conn, :update, reservation), reservation: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Reservation"
    end
  end

  describe "delete reservation" do
    setup [:create_reservation]

    test "deletes chosen reservation", %{conn: conn, reservation: reservation} do
      conn = delete conn, reservation_path(conn, :delete, reservation)
      assert redirected_to(conn) == reservation_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, reservation_path(conn, :show, reservation)
      end
    end
  end

  defp create_reservation(_) do
    reservation = fixture(:reservation)
    {:ok, reservation: reservation}
  end
end
