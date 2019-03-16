defmodule MetroWeb.CheckoutControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Order

  @create_attrs %{checkout_date: ~N[2010-04-17 14:00:00.000000], due_date: ~N[2010-04-17 14:00:00.000000], renewals_remaining: 42}
  @update_attrs %{checkout_date: ~N[2011-05-18 15:01:01.000000], due_date: ~N[2011-05-18 15:01:01.000000], renewals_remaining: 43}
  @invalid_attrs %{checkout_date: nil, due_date: nil, renewals_remaining: nil}

  def fixture(:checkout) do
    {:ok, checkout} = Order.create_checkout(@create_attrs)
    checkout
  end

  describe "index" do
    test "lists all checkouts", %{conn: conn} do
      conn = get conn, checkout_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Checkouts"
    end
  end

  describe "new checkout" do
    test "renders form", %{conn: conn} do
      conn = get conn, checkout_path(conn, :new)
      assert html_response(conn, 200) =~ "New Checkout"
    end
  end

  describe "create checkout" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, checkout_path(conn, :create), checkout: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == checkout_path(conn, :show, id)

      conn = get conn, checkout_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Checkout"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, checkout_path(conn, :create), checkout: @invalid_attrs
      assert html_response(conn, 200) =~ "New Checkout"
    end
  end

  describe "edit checkout" do
    setup [:create_checkout]

    test "renders form for editing chosen checkout", %{conn: conn, checkout: checkout} do
      conn = get conn, checkout_path(conn, :edit, checkout)
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

  describe "update checkout" do
    setup [:create_checkout]

    test "redirects when data is valid", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :update, checkout), checkout: @update_attrs
      assert redirected_to(conn) == checkout_path(conn, :show, checkout)

      conn = get conn, checkout_path(conn, :show, checkout)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :update, checkout), checkout: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

  describe "delete checkout" do
    setup [:create_checkout]

    test "deletes chosen checkout", %{conn: conn, checkout: checkout} do
      conn = delete conn, checkout_path(conn, :delete, checkout)
      assert redirected_to(conn) == checkout_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, checkout_path(conn, :show, checkout)
      end
    end
  end

  defp create_checkout(_) do
    checkout = fixture(:checkout)
    {:ok, checkout: checkout}
  end
end
