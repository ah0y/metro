defmodule MetroWeb.RoomController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Room

  def index(conn, _params) do
    rooms = Location.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Location.change_room(%Room{})
    libraries = Location.load_libraries()
    render(conn, "new.html", changeset: changeset, libraries: libraries)
  end

  def create(conn, %{"room" => room_params}) do
    case Location.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        libraries = Location.load_libraries()
        render(conn, "new.html", changeset: changeset, libraries: libraries)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Location.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    libraries = Location.load_libraries()
    room = Location.get_room!(id)
    changeset = Location.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset, libraries: libraries)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Location.get_room!(id)
    case Location.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        libraries = Location.load_libraries()
        render(conn, "edit.html", room: room, changeset: changeset, libraries: libraries)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Location.get_room!(id)
    {:ok, _room} = Location.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
