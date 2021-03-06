defmodule Metro.BookFactory do

  defmacro __using__(_opts) do
    quote do
      def book_factory do
        %Metro.Location.Book{
          title: "some title",
          image: "some image",
          isbn: sequence(:isbn, &(&1+ 1)),
          pages: 42,
          summary: "some summary",
          year: 42,
          author: build(:author),
        }
      end
      def with_unavailable_copies(%Metro.Location.Book{} = book) do
        insert(:copy_without_book_and_unavailable, book: book)
        book
      end
      def with_available_copies(%Metro.Location.Book{} = book) do
        insert(:copy_without_book_and_available, book: book)
        book
      end
      def with_waitlist(%Metro.Location.Book{} = book) do
        insert(:waitlist, book: book)
        book
      end
      def with_waitlist_nil(%Metro.Location.Book{} = book) do
        insert(:waitlist_with_nil, book: book)
        book
      end
      def book_without_author_factory do
        %Metro.Location.Book{
          title: sequence(:title, &"title-#{&1+1}"),
          image: "http://clipart-library.com/images/8czM9K7cp.jpg",
          isbn: sequence(:isbn, &(&1+ 1)),
          pages: 42,
          summary: "some summary",
          year: 42,
        }
      end
    end
  end
end


defmodule Metro.AuthorFactory do
  defmacro __using__(_opts) do
    quote do
      def author_factory do
        %Metro.Location.Author{
          bio: "some bio",
          first_name: sequence(:first_name, &"first_name-#{&1+1}"),
          last_name: sequence(:last_name, &"last_name-#{&1+1}"),
          location: "some location",
        }
      end
      def with_book(%Metro.Location.Author{} = author) do
        insert_list(10, :book_without_author, author: author)
        author
      end
      def with_ten_books(%Metro.Location.Author{} = author) do
        insert_list(10, :book_without_author, author: author)
        author
      end
    end
  end
end

defmodule Metro.CopyFactory do
  defmacro __using__(_opts) do
    quote do
      def copy_factory do
        %Metro.Location.Copy{
          checked_out?: true,
          library: build(:library),
          book: build(:book),
        }
      end

      def copy_without_book_and_unavailable_factory do
        %Metro.Location.Copy{
          checked_out?: true,
          library: build(:library),
        }
      end
      def copy_without_book_and_available_factory do
        %Metro.Location.Copy{
          checked_out?: false,
          library: build(:library),
        }
      end
      def copy_without_book_and_library_factory do
        %Metro.Location.Copy{
          checked_out?: false,
        }
      end
    end
  end
end

defmodule Metro.LibraryFactory do
  defmacro __using__(_opts) do
    quote do
      def library_factory do
        %Metro.Location.Library{
          address: "some address",
          image: "some image",
          hours: "some hours",
          branch: sequence(:branch, &"branch-#{&1+1}"),
        }
      end
    end
  end
end


defmodule Metro.EventFactory do
  defmacro __using__(_opts) do
    quote do
      def event_factory do
        %Metro.Location.Event{
          start_time:  ~N[2010-04-17 12:00:00.000000],
          end_time:  ~N[2010-04-17 14:00:00.000000],
          description: "some description",
          images: "some image",
        }
      end
    end
  end
end

defmodule Metro.RoomFactory do
  defmacro __using__(_opts) do
    quote do
      def room_factory do
        %Metro.Location.Room{
          capacity: 32,
          library: build(:library)
        }
      end
    end
  end
end

