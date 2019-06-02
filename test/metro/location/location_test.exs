defmodule Metro.LocationTest do
  use Metro.DataCase

  alias Metro.Location

  import Metro.Factory

  describe "libraries" do
    alias Metro.Location.Library

    @valid_attrs %{address: "some address", hours: "some hours", image: "some image", branch: "some branch"}
    @update_attrs %{address: "some updated address", hours: "some updated hours", image: "some updated image", branch: "some updated branch"}
    @invalid_attrs %{address: nil, hours: nil, image: nil}

    def library_fixture(attrs \\ %{}) do
      {:ok, library} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Location.create_library()

      library
    end

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Location.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Location.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      assert {:ok, %Library{} = library} = Location.create_library(@valid_attrs)
      assert library.address == "some address"
      assert library.hours == "some hours"
      assert library.image == "some image"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      assert {:ok, library} = Location.update_library(library, @update_attrs)
      assert %Library{} = library
      assert library.address == "some updated address"
      assert library.hours == "some updated hours"
      assert library.image == "some updated image"
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_library(library, @invalid_attrs)
      assert library == Location.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = Location.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> Location.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = Location.change_library(library)
    end
  end

  describe "authors" do
    alias Metro.Location.Author

    @valid_attrs %{bio: "some bio", first_name: "some first_name", last_name: "some last_name", location: "some location" }
    @update_attrs %{bio: "some updated bio", first_name: "some updated first_name", last_name: "some updated last_name", location: "some updated location"}
    @invalid_attrs %{bio: nil, first_name: nil, last_name: nil, location: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Location.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Location.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Location.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Location.create_author(@valid_attrs)
      assert author.bio == "some bio"
      assert author.first_name == "some first_name"
      assert author.last_name == "some last_name"
      assert author.location == "some location"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = Location.update_author(author, @update_attrs)
      assert %Author{} = author
      assert author.bio == "some updated bio"
      assert author.first_name == "some updated first_name"
      assert author.last_name == "some updated last_name"
      assert author.location == "some updated location"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_author(author, @invalid_attrs)
      assert author == Location.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Location.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Location.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Location.change_author(author)
    end
  end

  describe "rooms" do
    alias Metro.Location.Room

    @valid_attrs %{capacity: 42}
    @update_attrs %{capacity: 43}
    @invalid_attrs %{capacity: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Location.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Location.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Location.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Location.create_room(@valid_attrs)
      assert room.capacity == 42
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Location.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.capacity == 43
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_room(room, @invalid_attrs)
      assert room == Location.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Location.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Location.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Location.change_room(room)
    end
  end

  describe "books" do
    alias Metro.Location.Book
    @valid_attrs %{title: "some title",image: "some image", isbn: 42, pages: 42, summary: "some summary", year: 42}
    @update_attrs %{title: "some updated title",image: "some updated image", isbn: 43, pages: 43, summary: "some updated summary", year: 43}
    @invalid_attrs %{title: nil,image: nil, isbn: nil, pages: nil, summary: nil, year: nil}

    def book_fixture(attrs \\ %{}) do
      author = author_fixture()
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{author_id: author.id})
        |> Location.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Location.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Location.get_book!(book.isbn) == book
    end

    test "create_book/1 with valid data creates a book" do
      author = author_fixture()
      attrs = params_for(:book, %{author_id: author.id})
      assert {:ok, %Book{} = book} = Location.create_book(attrs)
      assert book.image == "some image"
      assert book.isbn == 42
      assert book.pages == 42
      assert book.summary == "some summary"
      assert book.year == 42
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, book} = Location.update_book(book, @update_attrs)
      assert %Book{} = book
      assert book.image == "some updated image"
      assert book.isbn == 43
      assert book.pages == 43
      assert book.summary == "some updated summary"
      assert book.year == 43
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_book(book, @invalid_attrs)
      assert book == Location.get_book!(book.isbn)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Location.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Location.get_book!(book.isbn) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Location.change_book(book)
    end
  end

  describe "copies" do
    alias Metro.Location.Copy

    @valid_attrs %{checked_out?: true}
    @update_attrs %{checked_out?: false}
    @invalid_attrs %{checked_out?: nil}

    def copy_fixture(attrs \\ %{}) do
      book = book_fixture()
      library = library_fixture()
      {:ok, copy} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{library_id: library.id})
        |> Enum.into(%{isbn_id: book.isbn})
        |> Location.create_copy()
      copy
    end

    test "find_copy/1 returns a copy if one is available" do
      book = build(:book)
             |> insert
             |> with_available_copies
      assert %Metro.Location.Copy{} = Location.find_copy(book.isbn)
    end

    test "find_copy/1 returns nil if no copies are available" do
      book = build(:book)
             |> insert
             |> with_unavailable_copies
      assert Location.find_copy(book.isbn) == nil
    end

    test "list_copies/0 returns all copies" do
      copy = copy_fixture()
      assert Location.list_copies() == [copy]
    end

    test "get_copy!/1 returns the copy with given id" do
      copy = copy_fixture()
      assert Location.get_copy!(copy.id) == copy
    end

    test "create_copy/1 with valid data creates a copy" do
      library = library_fixture()
      book = book_fixture()
      attrs = params_for(:copy, %{library_id: library.id, isbn_id: book.isbn})
      assert {:ok, %Copy{} = copy} = Location.create_copy(attrs)
      assert copy.checked_out? == true
    end

    test "create_copy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_copy(@invalid_attrs)
    end

    test "update_copy/2 with valid data updates the copy" do
      copy = copy_fixture()
      assert {:ok, copy} = Location.update_copy(copy, @update_attrs)
      assert %Copy{} = copy
      assert copy.checked_out? == false
    end

    test "update_copy/2 with invalid data returns error changeset" do
      copy = copy_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_copy(copy, @invalid_attrs)
      assert copy == Location.get_copy!(copy.id)
    end

    test "delete_copy/1 deletes the copy" do
      copy = copy_fixture()
      assert {:ok, %Copy{}} = Location.delete_copy(copy)
      assert_raise Ecto.NoResultsError, fn -> Location.get_copy!(copy.id) end
    end

    test "change_copy/1 returns a copy changeset" do
      copy = copy_fixture()
      assert %Ecto.Changeset{} = Location.change_copy(copy)
    end
  end

  describe "events" do
    alias Metro.Location.Event

    @valid_attrs %{datetime: ~N[2010-04-17 14:00:00.000000], description: "some description", images: "some images"}
    @update_attrs %{datetime: ~N[2011-05-18 15:01:01.000000], description: "some updated description", images: "some updated images"}
    @invalid_attrs %{datetime: nil, description: nil, images: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Location.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Location.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Location.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Location.create_event(@valid_attrs)
      assert event.datetime == ~N[2010-04-17 14:00:00]
      assert event.description == "some description"
      assert event.images == "some images"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Location.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Location.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.datetime == ~N[2011-05-18 15:01:01]
      assert event.description == "some updated description"
      assert event.images == "some updated images"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Location.update_event(event, @invalid_attrs)
      assert event == Location.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Location.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Location.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Location.change_event(event)
    end
  end
end
