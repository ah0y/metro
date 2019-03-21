defmodule MetroWeb.BookController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Book

  def index(conn, _params) do
    books = Location.list_books()
    render(conn, "index.html", books: books)
  end

  def new(conn, _params) do
    changeset = Location.change_book(%Book{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    case Location.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        Enum.map(changeset.errors, &handle_error(conn, changeset, &1))
    end
  end

  def show(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    changeset = Location.change_book(book)
    render(conn, "edit.html", book: book, changeset: changeset)
  end

  def update(conn, %{"isbn" => isbn, "book" => book_params}) do
    book = Location.get_book!(isbn)

    case Location.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", book: book, changeset: changeset)
    end
  end

  def delete(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    {:ok, _book} = Location.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: book_path(conn, :index))
  end

  defp handle_error(conn, _changeset,{:isbn, {"has already been taken", _}}) do
    conn
    |> redirect(to: copy_path(conn, :new))
  end

  defp handle_error(conn,changeset, {_some_key, _error_tuple}) do
    conn
    |> render("new.html", changeset: changeset)
  end
end
