defmodule MetroWeb.BookController do
  use MetroWeb, :controller

  alias Metro.Location
  alias Metro.Location.Author
  alias Metro.Location.Book
  alias Metro.Location.Genre
  alias Metro.Order
  alias Metro.Location.BookGenre

  alias Metro.Repo

  import Ecto.Query

  plug :authorize_resource, model: Book, id_name: "isbn", id_field: "isbn"
  use MetroWeb.ControllerAuthorization

  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => "author"
          }
        }
      ) do

    query_params = from b in Book,
                        join: a in Author,
                        where: a.id == b.author_id,
                        where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%")

    page = Metro.Repo.paginate(query_params, page: pagenumber)

    genres = Location.list_genres

    render conn, "index.html", books: page.entries, page: page, genres: genres
  end

  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => "author"
          }
        }
      ) do

    query_params = from b in Book,
                        join: a in Author,
                        where: a.id == b.author_id,
                        where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%")

    genres =
      Repo.all(
        from b in Book,
        left_join: g in assoc(b, :genres),
        where: not(is_nil(g.category)),
        group_by: g.id,
        select: %{
          category: g.category,
          count: count(g.id),
          id: g.id
        }
      )
    page = Metro.Repo.paginate(query_params, page: 1)

    render conn, "index.html", books: page.entries, page: page, genres: genres
  end

  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    query_params = from b in Book,
                        where: ilike(field(b, ^search_by), ^"%#{query}%")

    genres =
      Repo.all(
        from b in Book,
        left_join: g in assoc(b, :genres),
        where: not(is_nil(g.category)),
        group_by: g.id,
        select: %{
          category: g.category,
          count: count(g.id),
          id: g.id
        }
      )
    page = Metro.Repo.paginate(query_params, page: pagenumber)

    render conn, "index.html", books: page.entries, page: page, genres: genres
  end

  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    query_params = from b in Book,
                        where: ilike(field(b, ^search_by), ^"%#{query}%")
    genres =
      Repo.all(
        from b in Book,
        left_join: g in assoc(b, :genres),
        where: not(is_nil(g.category)),
        group_by: g.id,
        select: %{
          category: g.category,
          count: count(g.id),
          id: g.id
        }
      )
    page = Metro.Repo.paginate(query_params, page: 1)

    render conn, "index.html", books: page.entries, page: page, genres: genres
  end

  def index(conn, _params) do
    query_params = from b in Book
    #    genres = Location.list_genres
    pagenumber = conn.params["page"] || 1

    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    #todo this could be better!
    genres =
    Repo.all(
      from b in Book,
      left_join: g in assoc(b, :genres),
      where: not(is_nil(g.category)),
      group_by: g.id,
      select: %{
        category: g.category,
        count: count(g.id),
        id: g.id
      }
    )

#        require IEx; IEx.pry()

    render conn, "index.html", genres: genres, books: books, page: page
  end

  def new(conn, _params) do
    authors = Location.load_authors()
    changeset = Location.change_book(%Book{})
    genres = Location.list_genres()
    render(conn, "new.html", changeset: changeset, authors: authors, genres: genres)
  end

  def create(conn, %{"book" => book_params}) do
    #    require IEx;
    #    IEx.pry()

    case Location.create_book(book_params) do
      {:ok, book} ->
        if book_params["genres"] != nil do
          genres = Repo.all from g in Genre, where: g.id in ^book_params["genres"]
          genres = Repo.preload genres, :books
          book = Repo.preload(book, :genres)
          changeset = Book.changeset(book, %{})
                      |> Ecto.Changeset.put_assoc(:genres, genres)
          case Repo.update (changeset) do
            {:ok, book} ->
              conn
              |> put_flash(:info, "Book created successfully.")
              |> redirect(to: Routes.book_path(conn, :show, book))
            {:error, changeset} -> IO.puts("error")
            #todo better handing stuff here eventually
          end
        end
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        case Enum.at(changeset.errors, 0) do
          {:isbn, {"has already been taken", _}} ->
            redirect(conn, to: Routes.copy_path(conn, :new, isbn: book_params["isbn"]))
          {:author_id, {"can't be blank", [validation: :required]}} ->
            authors = Location.load_authors()
            render(conn, "new.html", changeset: changeset, authors: authors)
          {:author_id, {"is invalid", [type: :id, validation: :cast]}} ->
            try do
              [last, first] =
                String.split(book_params["author_id"], ",")
                |> Enum.map(&String.trim/1)
              attrs = %{last_name: last, first_name: first}
              {:ok, author} = Location.create_author(attrs)
              updated_book_params = Map.put(book_params, "author_id", author.id)
              case Location.create_book(updated_book_params) do
                {:ok, book} ->
                  conn
                  |> put_flash(:info, "Book created successfully.")
                  |> redirect(to: Routes.book_path(conn, :show, book))
                {:error, %Ecto.Changeset{} = changeset} ->
                  authors = Location.load_authors()
                  genres = Location.list_genres()
                  render(conn, "new.html", changeset: changeset, authors: authors, genres: genres)
              end
            rescue _ ->
              genres = Location.list_genres()
              authors = Location.load_authors()
              render(conn, "new.html", changeset: changeset, authors: authors, genres: genres)
            end
          _ ->
            authors = Location.load_authors()
            genres = Location.list_genres()
            render(conn, "new.html", changeset: changeset, authors: authors, genres: genres)
        end
    end
  end

  def show(conn, %{"isbn" => isbn}) do
    book = Location.get_book_and_copies(isbn)
    #    require IEx; IEx.pry()
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"isbn" => isbn}) do
    authors = Location.load_authors()
    book =
      Location.get_book!(isbn)
      |> Repo.preload([:genres, :author])
    changeset = Location.change_book(book)
    genres = Location.list_genres()
    render(conn, "edit.html", book: book, changeset: changeset, authors: authors, genres: genres)
  end

  def update(conn, %{"isbn" => isbn, "book" => book_params}) do
    book = Location.get_book!(isbn)


    case Location.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))
      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Location.load_authors()
        genres = Location.list_genres()
        render(conn, "edit.html", genres: genres, book: book, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"isbn" => isbn}) do
    book = Location.get_book!(isbn)
    {:ok, _book} = Location.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end