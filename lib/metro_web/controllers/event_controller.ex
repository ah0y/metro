defmodule MetroWeb.EventController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Event

  def index(conn, _params) do
    events = Location.list_events()
    {head, events} = List.pop_at(events, 0)
    render(conn, "index.html", events: events, head: head)
  end

  def new(conn, _params) do
    changeset = Location.change_event(%Event{})
    rooms = Location.load_rooms
    render(conn, "new.html", changeset: changeset, rooms: rooms)
  end

  def create(conn, %{"event" => event_params}) do
    case Location.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        rooms = Location.load_rooms
        render(conn, "new.html", changeset: changeset, rooms: rooms)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Location.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Location.get_event!(id)
    changeset = Location.change_event(event)
    rooms = Location.load_rooms
    render(conn, "edit.html", event: event, changeset: changeset, rooms: rooms)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Location.get_event!(id)

    case Location.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        rooms = Location.load_rooms
        render(conn, "edit.html", event: event, changeset: changeset, rooms: rooms)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Location.get_event!(id)
    {:ok, _event} = Location.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
