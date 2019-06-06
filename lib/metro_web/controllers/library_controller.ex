defmodule MetroWeb.LibraryController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Library

  plug :load_and_authorize_resource, model: Library
  use MetroWeb.ControllerAuthorization

  def index(conn, _params) do
    libraries = Location.list_libraries()
    render(conn, "index.html", libraries: libraries)
  end

  def new(conn, _params) do
    changeset = Location.change_library(%Library{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"library" => library_params}) do
    case Location.create_library(library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library created successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    library = Location.get_library!(id)
    render(conn, "show.html", library: library)
  end

  def edit(conn, %{"id" => id}) do
    library = Location.get_library!(id)
    changeset = Location.change_library(library)
    render(conn, "edit.html", library: library, changeset: changeset)
  end

  def update(conn, %{"id" => id, "library" => library_params}) do
    library = Location.get_library!(id)

    case Location.update_library(library, library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library updated successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", library: library, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    library = Location.get_library!(id)
    {:ok, _library} = Location.delete_library(library)

    conn
    |> put_flash(:info, "Library deleted successfully.")
    |> redirect(to: Routes.library_path(conn, :index))
  end
end
