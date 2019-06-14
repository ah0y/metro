defmodule MetroWeb.AuthorController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Book
  alias Metro.Location.Author

  import Ecto.Query


  plug :authorize_resource, model: Author
  use MetroWeb.ControllerAuthorization

  def index(conn, _params) do
    authors = Location.list_authors()
    render(conn, "index.html", authors: authors)
  end

  def new(conn, _params) do
    changeset = Location.change_author(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Location.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: Routes.author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "page" => pagenumber}) do
    author = Location.get_author!(id)

    page = Book
           |> where([b], b.author_id == ^id)
           |> Metro.Repo.paginate(page: pagenumber)

    render(conn, "show.html", page: page, books: page.entries, author: author)
  end

  def show(conn, %{"id" => id}) do
    author = Location.get_author!(id)

    query_params = from b in Book,
                        where: b.author_id == ^id

    page = Metro.Repo.paginate(query_params)

    render(conn, "show.html", page: page, books: page.entries, author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Location.get_author!(id)
    changeset = Location.change_author(author)
    render(conn, "edit.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Location.get_author!(id)

    case Location.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: Routes.author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Location.get_author!(id)
    {:ok, _author} = Location.delete_author(author)

    conn
    |> put_flash(:info, "Author deleted successfully.")
    |> redirect(to: Routes.author_path(conn, :index))
  end
end
