defmodule MetroWeb.WaitlistControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Order

  import Metro.Factory

  @create_attrs %{position: 42}
  @update_attrs %{position: 43}
  @invalid_attrs %{position: nil, copy_id: nil, checkout_id: nil, isbn_id: 0}

  def fixture(:waitlist) do
    checkout = insert(:checkout)
    attrs = %{checkout_id: checkout.id, isbn_id: checkout.isbn_id}
    waitlist = insert(:waitlist_without_book, attrs)
  end

  describe "index" do
    test "lists all waitlist", %{conn: conn} do
      conn = get conn, waitlist_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Waitlist"
    end
  end

  describe "new waitlist" do
    test "renders form", %{conn: conn} do
      conn = get conn, waitlist_path(conn, :new)
      assert html_response(conn, 200) =~ "New Waitlist"
    end
  end
  describe "create waitlist" do
    test "redirects to show when data is valid", %{conn: conn} do
      checkout = insert(:checkout)
      conn = post conn, waitlist_path(conn, :create), waitlist: %{checkout_id: checkout.id, isbn_id: checkout.isbn_id}

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == waitlist_path(conn, :show, id)

      conn = get conn, waitlist_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Waitlist"
    end
    
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, waitlist_path(conn, :create), waitlist: @invalid_attrs
      assert html_response(conn, 200) =~ "New Waitlist"
    end
  end

  describe "edit waitlist" do
    setup [:create_waitlist]

    test "renders form for editing chosen waitlist", %{conn: conn, waitlist: waitlist} do
      conn = get conn, waitlist_path(conn, :edit, waitlist)
      assert html_response(conn, 200) =~ "Edit Waitlist"
    end
  end

  describe "update waitlist" do
    setup [:create_waitlist]

    test "redirects when data is valid", %{conn: conn, waitlist: waitlist} do
      conn = put conn, waitlist_path(conn, :update, waitlist), waitlist: @update_attrs
      assert redirected_to(conn) == waitlist_path(conn, :show, waitlist)

      conn = get conn, waitlist_path(conn, :show, waitlist)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, waitlist: waitlist} do
      conn = put conn, waitlist_path(conn, :update, waitlist), waitlist: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Waitlist"
    end
  end

  describe "delete waitlist" do
    setup [:create_waitlist]

    test "deletes chosen waitlist", %{conn: conn, waitlist: waitlist} do
      conn = delete conn, waitlist_path(conn, :delete, waitlist)
      assert redirected_to(conn) == waitlist_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, waitlist_path(conn, :show, waitlist)
      end
    end
  end

  defp create_waitlist(_) do
    waitlist = fixture(:waitlist)
    {:ok, waitlist: waitlist}
  end
end
