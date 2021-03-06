defmodule MetroWeb.BookControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location

  import Metro.Factory

  @create_attrs %{title: "some title", image: "some image", isbn: 42, pages: 42, summary: "some summary", year: 42}
  @update_attrs %{
    title: "some updated title",
    image: "some updated image",
    isbn: 42,
    pages: 43,
    summary: "some updated summary",
    year: 43
  }
  @invalid_attrs %{title: nil, image: nil, isbn: nil, pages: nil, summary: nil, year: nil}
  def fixture(:book) do
    author = insert(:author)
    {:ok, book} = Location.create_book(Enum.into(@create_attrs, %{author_id: author.id}))
    book
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get conn, book_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Books"
    end
  end

  describe "new book" do
    setup do
      user = build(:admin)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
      [conn: conn]
    end

    test "renders form", %{conn: conn} do
      conn = get conn, book_path(conn, :new)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    setup do
      user = build(:admin)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
    {:ok, conn: conn}
    end
    test "redirects to show when data is valid", %{conn: conn} do
      author = insert(:author)
      attrs = params_for(:book, %{author_id: author.id})
      conn = post conn, book_path(conn, :create), book: attrs

      assert %{isbn: isbn} = redirected_params(conn)
      assert redirected_to(conn) == book_path(conn, :show, isbn)

      conn = get conn, book_path(conn, :show, isbn)
      assert html_response(conn, 200) =~ "some title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @invalid_attrs
      assert html_response(conn, 200) =~ "New Book"
    end

    test "routes to Copy/new when creating a book with an existing isbn", %{conn: conn} do
      author = insert(:author)
      attrs = params_for(:book, %{isbn: 42, author_id: author.id})
      conn = post conn, book_path(conn, :create), book: attrs

      assert %{isbn: isbn} = redirected_params(conn)
      assert redirected_to(conn) == book_path(conn, :show, isbn)

      conn = post conn, "/books", book: attrs

      assert redirected_to(conn) == copy_path(conn, :new, isbn: isbn)
    end

    test "creates a new author if one is entered that doesn't already exist", %{conn: conn}  do
      conn = post conn, "/books", book: Enum.into(@create_attrs, %{author_id: "author, new"})
      assert get_flash(conn, :info) == "Book created successfully."
    end
  end

  #  @moduletag book_show_case: "book show"
  #  describe "show book" do
  #    setup [:create_book]
  #    test "routes to checkout/new when placing a hold on a book with an available copy ", %{conn: conn, book: book} do
  #      book =
  #        book
  #        |> with_available_copies
  #      conn = post conn, book_path(conn, :checkout, book)
  #      assert redirected_to(conn) == checkout_path(conn, :new, isbn: book.isbn)
  #    end
  #  end

  describe "edit book" do
    setup [:create_book]

    test "renders form for editing chosen book", %{conn: conn, book: book} do
      conn = get conn, book_path(conn, :edit, book)
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "update book" do
    setup [:create_book]

    test "redirects when data is valid", %{conn: conn, book: book} do
      conn = put conn, book_path(conn, :update, book), book: @update_attrs
      assert redirected_to(conn) == book_path(conn, :show, book)

      conn = get conn, book_path(conn, :show, book)
      assert html_response(conn, 200) =~ "some updated image"
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put conn, book_path(conn, :update, book), book: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete conn, book_path(conn, :delete, book)
      assert redirected_to(conn) == book_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, book_path(conn, :show, book)
      end
    end
  end

  defp create_book(_) do
    user = build(:admin)
           |> with_card
    attrs = Map.take(user, [:email, :password_hash, :password])
    conn = post(build_conn(), "/sessions", %{session: attrs})
    book = fixture(:book)
    {:ok, conn: conn, book: book}
  end

  #  defp create_book_with_available_copies(_) do
  #    book = build(:book)
  #           |> insert
  #           |> with_available_copies
  #
  #    book = Repo.preload(book, :copies)
  #  end
end
