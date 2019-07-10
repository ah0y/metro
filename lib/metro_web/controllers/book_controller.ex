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

  #searching with only genres with paging
  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "genres" => genres,
            "query" => "",
            "search_by" => _,
            "years" => years
          }
        }
      ) do

    genres = Enum.map(conn.params["search"]["genres"], &String.to_integer/1)

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    query_params = from b in Book,
                        join: g in assoc(b, :genres),
                        group_by: b.isbn,
                        having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)

    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end

  #searching with only genres first page
  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "genres" => genres,
            "query" => "",
            "search_by" => _,
            "years" => years
          }
        }
      ) do

    genres = Enum.map(conn.params["search"]["genres"], &String.to_integer/1)

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    query_params = from b in Book,
                        join: g in assoc(b, :genres),
                        group_by: b.isbn,
                        where: b.year >= ^b_year and b.year <= ^e_year,
                        having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)

    page = Metro.Repo.paginate(query_params, page: 1)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end

  #first page
  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => "",
            "search_by" => _,
            "years" => years
          }
        }
      ) do

    query_params = from b in Book
    #    genres = Location.list_genres
    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    pagenumber = conn.params["page"] || 1

    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    #todo this could be better!
    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", genres: genres, books: books, page: page, min: min, max: max
  end

  #searching with checkboxes and author paging
  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => "author",
            "years" => years
          }
        }
      ) do

    genres =
      case conn.params["search"]["genres"] do
        nil -> Enum.to_list 1..27
        _ -> Enum.map(conn.params["search"]["genres"], &String.to_integer/1)
      end

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    query_params =
      case conn.params["search"]["genres"] do
        nil -> from b in Book,
                    join: a in Author,
                    join: g in assoc(b, :genres),
                    group_by: b.isbn,
                    where: a.id == b.author_id,
                    where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%"),
                    where: b.year >= ^b_year and b.year <= ^e_year,
                    having: fragment("ARRAY_AGG(?::integer) <@ ?", g.id, ^genres)
        _ -> from b in Book,
                  join: a in Author,
                  join: g in assoc(b, :genres),
                  group_by: b.isbn,
                  where: a.id == b.author_id,
                  where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%"),
                  where: b.year >= ^b_year and b.year <= ^e_year,
                  having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)
      end

    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end

  #searching with checkboxes and author first page
  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => "author",
            "years" => years
          }
        }
      ) do

    genres =
      case conn.params["search"]["genres"] do
        nil -> Enum.to_list 1..27
        _ -> Enum.map(conn.params["search"]["genres"], &String.to_integer/1)
      end

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    query_params =
      case conn.params["search"]["genres"] do
        nil -> from b in Book,
                    join: a in Author,
                    join: g in assoc(b, :genres),
                    group_by: b.isbn,
                    where: a.id == b.author_id,
                    where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%"),
                    where: b.year >= ^b_year and b.year <= ^e_year,
                    having: fragment("ARRAY_AGG(?::integer) <@ ?", g.id, ^genres)
        _ -> from b in Book,
                  join: a in Author,
                  join: g in assoc(b, :genres),
                  group_by: b.isbn,
                  where: a.id == b.author_id,
                  where: ilike(a.last_name, ^"%#{query}%") or ilike(a.first_name, ^"%#{query}%"),
                  where: b.year >= ^b_year and b.year <= ^e_year,
                  having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)
      end



    page = Metro.Repo.paginate(query_params, page: 1)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end

  #searching with checkboxes and title/summary paging
  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by,
            "years" => years
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    genres =
      case conn.params["search"]["genres"] do
        nil -> Enum.to_list 1..27
        _ -> Enum.map(conn.params["search"]["genres"], &String.to_integer/1)
      end

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    query_params =
      case conn.params["search"]["genres"] do
        nil -> from b in Book,
                    join: g in assoc(b, :genres),
                    group_by: b.isbn,
                    where: ilike(field(b, ^search_by), ^"%#{query}%"),
                    where: b.year >= ^b_year and b.year <= ^e_year,
                    having: fragment("ARRAY_AGG(?::integer) <@ ?", g.id, ^genres)
        _ -> from b in Book,
                  join: g in assoc(b, :genres),
                  group_by: b.isbn,
                  where: ilike(field(b, ^search_by), ^"%#{query}%"),
                  where: b.year >= ^b_year and b.year <= ^e_year,
                  having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)
      end


    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end

  #searching with checkboxes and title/summary first page
  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by,
            "years" => years
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    genres =
      case conn.params["search"]["genres"] do
        nil -> Enum.to_list 1..27
        _ -> Enum.map(conn.params["search"]["genres"], &String.to_integer/1)
      end

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)


    query_params =
      case conn.params["search"]["genres"] do
        nil -> from b in Book,
                    join: g in assoc(b, :genres),
                    group_by: b.isbn,
                    where: ilike(field(b, ^search_by), ^"%#{query}%"),
                    where: b.year >= ^b_year and b.year <= ^e_year,
                    having: fragment("ARRAY_AGG(?::integer) <@ ?", g.id, ^genres)
        _ -> from b in Book,
                  join: g in assoc(b, :genres),
                  group_by: b.isbn,
                  where: ilike(field(b, ^search_by), ^"%#{query}%"),
                  where: b.year >= ^b_year and b.year <= ^e_year,
                  having: fragment("ARRAY_AGG(?::integer) @> ?", g.id, ^genres)
      end

#    require IEx; IEx.pry()


    page = Metro.Repo.paginate(query_params, page: 1)
    books = Repo.preload(page.entries, :genres)

    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    render conn, "index.html", books: books, page: page, genres: genres, min: min, max: max
  end


  #searching with no params
  def index(conn, _params) do
    query_params = from b in Book
    #    genres = Location.list_genres
    pagenumber = conn.params["page"] || 1

    page = Metro.Repo.paginate(query_params, page: pagenumber)
    books = Repo.preload(page.entries, :genres)

    #todo this could be better!
    genres =
      Metro.Repo.all(query_params)
      |> Repo.preload(:genres)
      |> Enum.map(fn book -> Map.get(book, :genres) end)
      |> List.flatten
      |> Enum.group_by(fn g -> {g.id, g.category} end)
      |> Enum.map(fn {{id, category}, list} -> %{id: id, category: category, count: length(list)}   end)

    [{min, max}] = Repo.all(from b in Book, select: {min(b.year), max(b.year)})
#    [b_year, e_year] = Enum.map(String.split(years, [" ", "-"], trim: true), &String.to_integer/1)

    render conn, "index.html", genres: genres, books: books, page: page, min: min, max: max
  end

  def new(conn, _params) do
    authors = Location.load_authors()
    changeset = Location.change_book(%Book{})
    genres = Location.list_genres()
    render(conn, "new.html", changeset: changeset, authors: authors, genres: genres)
  end

  def create(conn, %{"book" => book_params}) do
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