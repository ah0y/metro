defmodule MetroWeb.CopyControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location

  import Metro.Factory

  @create_attrs %{checked_out?: true}
  @update_attrs %{checked_out?: false}
  @invalid_attrs %{checked_out?: nil}

  def fixture(:copy) do
    library = insert(:library)
    book = insert(:book)
    {:ok, copy} = Location.create_copy(Enum.into(@create_attrs, %{library_id: library.id, isbn_id: book.isbn}))
    copy
  end

  describe "index" do
    test "lists all copies", %{conn: conn} do
      conn = get conn, copy_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Copies"
    end
  end

  describe "new copy" do
    test "renders form", %{conn: conn} do
      conn = get conn, copy_path(conn, :new)
      assert html_response(conn, 200) =~ "New Copy"
    end
  end

  describe "create copy" do
    test "redirects to show when data is valid", %{conn: conn} do
      library = insert(:library)
      book = insert(:book)
      attrs = params_for(:copy, %{library_id: library.id, isbn_id: book.isbn})
      conn = post conn, copy_path(conn, :create), copy: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == copy_path(conn, :show, id)

      conn = get conn, copy_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Copy"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, copy_path(conn, :create), copy: @invalid_attrs
      assert html_response(conn, 200) =~ "New Copy"
    end
  end

  describe "edit copy" do
    setup [:create_copy]

    test "renders form for editing chosen copy", %{conn: conn, copy: copy} do
      conn = get conn, copy_path(conn, :edit, copy)
      assert html_response(conn, 200) =~ "Edit Copy"
    end
  end

  describe "update copy" do
    setup [:create_copy]

    test "redirects when data is valid", %{conn: conn, copy: copy} do
      conn = put conn, copy_path(conn, :update, copy), copy: @update_attrs
      assert redirected_to(conn) == copy_path(conn, :show, copy)

      conn = get conn, copy_path(conn, :show, copy)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, copy: copy} do
      conn = put conn, copy_path(conn, :update, copy), copy: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Copy"
    end
  end

  describe "delete copy" do
    setup [:create_copy]

    test "deletes chosen copy", %{conn: conn, copy: copy} do
      conn = delete conn, copy_path(conn, :delete, copy)
      assert redirected_to(conn) == copy_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, copy_path(conn, :show, copy)
      end
    end
  end

  defp create_copy(_) do
    copy = fixture(:copy)
    {:ok, copy: copy}
  end
end
