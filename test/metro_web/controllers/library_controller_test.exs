defmodule MetroWeb.LibraryControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location

  @create_attrs %{address: "some address", hours: "some hours", image: "some image"}
  @update_attrs %{address: "some updated address", hours: "some updated hours", image: "some updated image"}
  @invalid_attrs %{address: nil, hours: nil, image: nil}

  def fixture(:library) do
    {:ok, library} = Location.create_library(@create_attrs)
    library
  end

  describe "index" do
    test "lists all libraries", %{conn: conn} do
      conn = get conn, library_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Libraries"
    end
  end

  describe "new library" do
    test "renders form", %{conn: conn} do
      conn = get conn, library_path(conn, :new)
      assert html_response(conn, 200) =~ "New Library"
    end
  end

  describe "create library" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, library_path(conn, :create), library: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == library_path(conn, :show, id)

      conn = get conn, library_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Library"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, library_path(conn, :create), library: @invalid_attrs
      assert html_response(conn, 200) =~ "New Library"
    end
  end

  describe "edit library" do
    setup [:create_library]

    test "renders form for editing chosen library", %{conn: conn, library: library} do
      conn = get conn, library_path(conn, :edit, library)
      assert html_response(conn, 200) =~ "Edit Library"
    end
  end

  describe "update library" do
    setup [:create_library]

    test "redirects when data is valid", %{conn: conn, library: library} do
      conn = put conn, library_path(conn, :update, library), library: @update_attrs
      assert redirected_to(conn) == library_path(conn, :show, library)

      conn = get conn, library_path(conn, :show, library)
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, library: library} do
      conn = put conn, library_path(conn, :update, library), library: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Library"
    end
  end

  describe "delete library" do
    setup [:create_library]

    test "deletes chosen library", %{conn: conn, library: library} do
      conn = delete conn, library_path(conn, :delete, library)
      assert redirected_to(conn) == library_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, library_path(conn, :show, library)
      end
    end
  end

  defp create_library(_) do
    library = fixture(:library)
    {:ok, library: library}
  end
end
