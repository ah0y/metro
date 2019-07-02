defmodule Metro.Location do
  @moduledoc """
  The Location context.
  """

  import Ecto.Query, warn: false
  alias Metro.Repo

  alias Metro.Location.Library

  @doc """
  Returns the list of libraries.

  ## Examples

      iex> list_libraries()
      [%Library{}, ...]

  """
  def list_libraries do
    Repo.all(Library)
  end

  @doc """
  Loads a list of library branch and library ids.

  ## Examples

      iex> load_libraries()
      [%Library{}, ...]

  """
  def load_libraries do
    query =
      Library
      |> Library.branch_and_ids
    libraries = Repo.all query
  end

  @doc """
  Gets a single library.

  Raises `Ecto.NoResultsError` if the Library does not exist.

  ## Examples

      iex> get_library!(123)
      %Library{}

      iex> get_library!(456)
      ** (Ecto.NoResultsError)

  """
  def get_library!(id), do: Repo.get!(Library, id)

  @doc """
  Creates a library.

  ## Examples

      iex> create_library(%{field: value})
      {:ok, %Library{}}

      iex> create_library(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_library(attrs \\ %{}) do
    %Library{}
    |> Library.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a library.

  ## Examples

      iex> update_library(library, %{field: new_value})
      {:ok, %Library{}}

      iex> update_library(library, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_library(%Library{} = library, attrs) do
    library
    |> Library.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Library.

  ## Examples

      iex> delete_library(library)
      {:ok, %Library{}}

      iex> delete_library(library)
      {:error, %Ecto.Changeset{}}

  """
  def delete_library(%Library{} = library) do
    Repo.delete(library)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking library changes.

  ## Examples

      iex> change_library(library)
      %Ecto.Changeset{source: %Library{}}

  """
  def change_library(%Library{} = library) do
    Library.changeset(library, %{})
  end

  alias Metro.Location.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Loads a list of author ids and first and last names concatenated and assigns it to conn.

  ## Examples

      iex> load_authors()
      [%Author{}, ...]

  """
  def load_authors  do
    query =
      Author
      |> Author.names_and_ids
    authors = Repo.all query
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Gets a single author and preloads all books of that author.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_author_and_books(123)
      %Book{}

      iex> get_author_and_books(456)
      ** (Ecto.NoResultsError)

  """
  def get_author_and_books(id),
      do: Repo.get!(Author, id)
          |> Repo.preload(:books)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  alias Metro.Location.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def load_rooms do
    query =
      Room
      |> Room.room_name
    authors = Repo.all query
  end
  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  alias Metro.Location.Book
  alias Metro.Location.Genre

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Gets a single book and preloads all copies of that book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book_and_copies(123)
      %Book{}

      iex> get_book_and_copies(456)
      ** (Ecto.NoResultsError)

  """
  def get_book_and_copies(id),
      do: Repo.get!(Book, id)
          |> Repo.preload(:copies)
          |> Repo.preload(:author)

  alias Metro.Location.Copy
  @doc """
  Returns a single copy of a book if one is available, if not returns nil.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> find_copy(123)
      %Book{}

      iex> find_copy(456)
      ** (Ecto.NoResultsError)

  """
  def find_copy(isbn_id) do
    Repo.one(
      from c in Copy,
      where: c.isbn_id == ^isbn_id and c.checked_out? == false, limit: 1
    )
  end

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    genres = Repo.all from g in Genre, where: g.id in ^attrs["genres"]
    genres = Repo.preload genres, :books
    book
    |> Repo.preload(:genres)
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:genres, genres)
    |> Repo.update()
  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{source: %Book{}}

  """
  def change_book(%Book{} = book) do
    Book.changeset(book, %{})
  end

  alias Metro.Location.Copy

  @doc """
  Returns the list of copies.

  ## Examples

      iex> list_copies()
      [%Copy{}, ...]

  """
  def list_copies do
    Repo.all(Copy)
  end

  @doc """
  Gets a single copy.

  Raises `Ecto.NoResultsError` if the Copy does not exist.

  ## Examples

      iex> get_copy!(123)
      %Copy{}

      iex> get_copy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_copy!(id), do: Repo.get!(Copy, id)

  @doc """
  Creates a copy.

  ## Examples

      iex> create_copy(%{field: value})
      {:ok, %Copy{}}

      iex> create_copy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_copy(attrs \\ %{}) do
    %Copy{}
    |> Copy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a copy.

  ## Examples

      iex> update_copy(copy, %{field: new_value})
      {:ok, %Copy{}}

      iex> update_copy(copy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_copy(%Copy{} = copy, attrs) do
    copy
    |> Copy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Copy.

  ## Examples

      iex> delete_copy(copy)
      {:ok, %Copy{}}

      iex> delete_copy(copy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_copy(%Copy{} = copy) do
    Repo.delete(copy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking copy changes.

  ## Examples

      iex> change_copy(copy)
      %Ecto.Changeset{source: %Copy{}}

  """
  def change_copy(%Copy{} = copy) do
    Copy.changeset(copy, %{})
  end

  alias Metro.Location.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end


  alias Metro.Location.Genre
  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(Genre)
  end
end
