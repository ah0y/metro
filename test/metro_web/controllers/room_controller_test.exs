defmodule MetroWeb.RoomControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location

  import Metro.Factory

  @create_attrs %{capacity: 42}
  @update_attrs %{capacity: 43}
  @invalid_attrs %{capacity: nil}
  setup do
    user = build(:admin)
           |> with_card
    attrs = Map.take(user, [:email, :password_hash, :password])
    conn = post(build_conn(), "/sessions", %{session: attrs})
    [conn: conn]
  end

  def fixture(:room) do
    library = insert(:library)
    {:ok, room} = Location.create_room(Enum.into(@create_attrs, %{library_id: library.id}))
    room
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get conn, room_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

  describe "new room" do
    test "renders form", %{conn: conn} do
      conn = get conn, room_path(conn, :new)
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      library = insert(:library)
      attrs = params_for(:room, %{library_id: library.id})
      conn = post conn, room_path(conn, :create), room: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == room_path(conn, :show, id)

      conn = get conn, room_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Room"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, room_path(conn, :create), room: @invalid_attrs
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  describe "edit room" do
    setup [:create_room]

    test "renders form for editing chosen room", %{conn: conn, room: room} do
      conn = get conn, room_path(conn, :edit, room)
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "update room" do
    setup [:create_room]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put conn, room_path(conn, :update, room), room: @update_attrs
      assert redirected_to(conn) == room_path(conn, :show, room)

      conn = get conn, room_path(conn, :show, room)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put conn, room_path(conn, :update, room), room: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete conn, room_path(conn, :delete, room)
      assert redirected_to(conn) == room_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, room_path(conn, :show, room)
      end
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    {:ok, room: room}
  end
end
