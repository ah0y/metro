defmodule MetroWeb.BookController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Book

  def index(conn, _params) do
    books = Location.list_books()
    render(conn, "index.html", books: books)
  end

  def new(conn, _params) do
    authors = Location.load_authors()
    changeset = Location.change_book(%Book{})
    render(conn, "new.html", changeset: changeset, authors: authors)
  end

  def create(conn, %{"book" => book_params}) do
#    require IEx; IEx.pry()
    case Location.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        case Enum.at(changeset.errors, 0) do
          {:isbn, {"has already been taken", _}} ->
            redirect(conn, to: copy_path(conn, :new))
           _ ->
             authors = Location.load_authors()
             render(conn, "new.html", changeset: changeset, authors: authors)
        end
    end
  end

  def show(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"isbn" => isbn}) do
    authors = Location.load_authors()
    book = Location.get_book!(isbn)
    changeset = Location.change_book(book)
    render(conn, "edit.html", book: book, changeset: changeset, authors: authors)
  end

  def update(conn, %{"isbn" => isbn, "book" => book_params}) do
    book = Location.get_book!(isbn)

    case Location.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Location.load_authors()
        render(conn, "edit.html", book: book, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    {:ok, _book} = Location.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: book_path(conn, :index))
  end



end
