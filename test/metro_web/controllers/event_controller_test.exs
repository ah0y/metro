defmodule MetroWeb.EventControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location

  import Metro.Factory

  @create_attrs %{start_time: ~N[2010-04-17 14:00:00.000000], end_time: ~N[2011-04-17 15:01:01.000000], description: "some description", images: "some images"}
  @update_attrs %{start_time: ~N[2010-04-17 12:00:00.000000], end_time: ~N[2011-04-17 15:01:01.000000], description: "some updated description", images: "some updated images"}
  @invalid_attrs %{start_time: nil, end_time: nil, description: nil, images: nil}
  @moduletag :event
  setup do
    user = build(:admin)
           |> with_card
    attrs = Map.take(user, [:email, :password_hash, :password])
    conn = post(build_conn(), "/sessions", %{session: attrs})
    [conn: conn]
  end

  def fixture(:event) do
    room = insert(:room)
    {:ok, event} = Location.create_event(Enum.into(@create_attrs, %{room_id: room.id}))
    event
  end

#  describe "index" do
#    setup [:create_event]
#
#    test "lists all events", %{conn: conn} do
#      conn = get conn, event_path(conn, :index)
#      assert html_response(conn, 200) =~ "Listing Events"
#    end
#  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get conn, event_path(conn, :new)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      room = insert(:room)
      attrs = params_for(:event, %{room_id: room.id})
      conn = post conn, event_path(conn, :create), event: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == event_path(conn, :show, id)

      conn = get conn, event_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get conn, event_path(conn, :edit, event)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
