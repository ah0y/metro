defmodule MetroWeb.TransitControllerTest do
  use MetroWeb.ConnCase

  import Metro.Factory

  alias Metro.Order

  @create_attrs %{actual_arrival: ~N[2010-04-17 14:00:00.000000], estimated_arrival: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{actual_arrival: ~N[2011-05-18 15:01:01.000000], estimated_arrival: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{actual_arrival: nil, estimated_arrival: nil, checkout_id: nil}


  def fixture(:transit) do
    transit = insert(:transit)
  end

  describe "index" do
    test "lists all transit", %{conn: conn} do
      conn = get conn, transit_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Transit"
    end
  end

  describe "new transit" do
    test "renders form", %{conn: conn} do
      conn = get conn, transit_path(conn, :new)
      assert html_response(conn, 200) =~ "New Transit"
    end
  end

  describe "create transit" do
    test "redirects to show when data is valid", %{conn: conn} do
      checkout = insert(:checkout)

      conn = post conn, transit_path(conn, :create), transit: params_for(:transit) |> Enum.into(checkout_id: checkout.id)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == transit_path(conn, :show, id)

      conn = get conn, transit_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Transit"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, transit_path(conn, :create), transit: @invalid_attrs
      assert html_response(conn, 200) =~ "New Transit"
    end
  end

  describe "edit transit" do
    setup [:create_transit]

    test "renders form for editing chosen transit", %{conn: conn, transit: transit} do
      conn = get conn, transit_path(conn, :edit, transit)
      assert html_response(conn, 200) =~ "Edit Transit"
    end
  end

  describe "update transit" do
    setup [:create_transit]

    test "redirects when data is valid", %{conn: conn, transit: transit} do
      conn = put conn, transit_path(conn, :update, transit), transit: @update_attrs
      assert redirected_to(conn) == transit_path(conn, :show, transit)

      conn = get conn, transit_path(conn, :show, transit)
      assert html_response(conn, 200)
    end

    test "with empty checkout params, completes a transit", %{conn: conn, transit: transit} do
      attrs = params_for(:reservation)
              |> Enum.into(%{transit_id: transit.id})
      {:ok, reservation} = Order.create_reservation(attrs)

      conn = put conn, transit_path(conn, :update, transit)
      assert redirected_to(conn) == transit_path(conn, :index)

      conn = get conn, transit_path(conn, :show, transit)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, transit: transit} do
      conn = put conn, transit_path(conn, :update, transit), transit: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Transit"
    end
  end

  describe "delete transit" do
    setup [:create_transit]

    test "deletes chosen transit", %{conn: conn, transit: transit} do
      conn = delete conn, transit_path(conn, :delete, transit)
      assert redirected_to(conn) == transit_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, transit_path(conn, :show, transit)
      end
    end
  end

  defp create_transit(_) do
    transit = fixture(:transit)
    {:ok, transit: transit}
  end
end
