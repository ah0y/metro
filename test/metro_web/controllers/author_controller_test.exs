defmodule MetroWeb.AuthorControllerTest do
  use MetroWeb.ConnCase

  import Metro.Factory

  alias Metro.Location

  @create_attrs %{
    bio: "some bio",
    first_name: "some first_name",
    last_name: "some last_name",
    location: "some location"
  }
  @update_attrs %{
    bio: "some updated bio",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    location: "some updated location"
  }
  @invalid_attrs %{bio: nil, first_name: nil, last_name: nil, location: nil}


  def fixture(:author) do
    {:ok, author} = Location.create_author(@create_attrs)
    author
  end

  describe "index" do
    setup do
      user = build(:user)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
      {:ok, conn: conn}
    end

    test "lists all authors", %{conn: conn} do
      conn = get conn, author_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Authors"
    end
  end

  describe "new author" do
    setup do
      user = build(:admin)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
      {:ok, conn: conn}
    end
    test "renders form", %{conn: conn} do
      conn = get conn, author_path(conn, :new)
      assert html_response(conn, 200) =~ "New Author"
    end
  end

  describe "create author" do
    setup do
      user = build(:admin)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
      {:ok, conn: conn}
    end
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, author_path(conn, :create), author: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == author_path(conn, :show, id)

      conn = get conn, author_path(conn, :show, id)
      assert html_response(conn, 200) =~ "some first_name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, author_path(conn, :create), author: @invalid_attrs
      assert html_response(conn, 200) =~ "New Author"
    end
  end

  describe "edit author" do
    setup [:create_author]

    test "renders form for editing chosen author", %{conn: conn, author: author} do
      conn = get conn, author_path(conn, :edit, author)
      assert html_response(conn, 200) =~ "Edit Author"
    end
  end

  describe "update author" do
    setup [:create_author]

    test "redirects when data is valid", %{conn: conn, author: author} do
      conn = put conn, author_path(conn, :update, author), author: @update_attrs
      assert redirected_to(conn) == author_path(conn, :show, author)

      conn = get conn, author_path(conn, :show, author)
      assert html_response(conn, 200) =~ "some updated bio"
    end

    test "renders errors when data is invalid", %{conn: conn, author: author} do
      conn = put conn, author_path(conn, :update, author), author: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Author"
    end
  end

  describe "delete author" do
    setup [:create_author]

    test "deletes chosen author", %{conn: conn, author: author} do
      conn = delete conn, author_path(conn, :delete, author)
      assert redirected_to(conn) == author_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, author_path(conn, :show, author)
      end
    end
  end

  defp create_author(_) do
    author = fixture(:author)
    user = build(:admin)
           |> with_card
    attrs = Map.take(user, [:email, :password_hash, :password])
    conn = post(build_conn(), "/sessions", %{session: attrs})
    {:ok, author: author, conn: conn}
  end
end
