defmodule MetroWeb.BookControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Location
  alias Metro.Repo

  @create_attrs %{title: "some title", image: "some image", isbn: 42, pages: 42, summary: "some summary", year: 42}
  @update_attrs %{title: "some updated title",image: "some updated image", isbn: 42, pages: 43, summary: "some updated summary", year: 43}
  @invalid_attrs %{title: nil, image: nil, isbn: nil, pages: nil, summary: nil, year: nil}

  def fixture(:book) do
    {:ok, book} = Location.create_book(@create_attrs)
    book
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get conn, book_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Books"
    end
  end

  describe "new book" do
    test "renders form", %{conn: conn} do
      conn = get conn, book_path(conn, :new)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @create_attrs

      assert %{isbn: isbn} = redirected_params(conn)
      assert redirected_to(conn) == book_path(conn, :show, isbn)

      conn = get conn, book_path(conn, :show, isbn)
      assert html_response(conn, 200) =~ "Show Book"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @invalid_attrs
      assert html_response(conn, 200) =~ "New Book"
    end


    test "routes to Copy/new when creating a book with an existing isbn", %{conn: conn} do
      conn = post conn, book_path(conn, :create), book: @create_attrs
      assert %{isbn: isbn} = redirected_params(conn)
      assert redirected_to(conn) == book_path(conn, :show, isbn)

      conn = post(build_conn(), "/books", book: @create_attrs)
      assert redirected_to(conn) == copy_path(conn, :new)
    end

    test "creates a new author if one is entered that doesn't already exist" do

    end

    test "builds proper association when an existing author is selected" do


    end
  end

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
    book = fixture(:book)
    {:ok, book: book}
  end
end
