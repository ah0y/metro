defmodule MetroWeb.UserControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Account

  import Metro.Factory

  @create_attrs %{
    name: "some user",
    email: "test@foo.com",
    password_hash: "$2b$12$XLGRLrhRbzLiicATx7Zihe2hXdqrkpbN4cSwD.w0e/LpZtvh.TkcS",
    password: "password",
    fines: 0.00,
    num_books_out: 0,
    is_librarian?: false,
  }
  @update_attrs %{
    name: "some updated user",
    email: "updatedtest@foo.com",
    fines: 1.00,
    num_books_out: 1,
    is_librarian?: true,
  }
  @invalid_attrs %{
    name: nil,
    email: nil,
    password_hash: nil,
    fines: nil,
    num_books_out: nil,
    is_librarian?: nil,
  }

  def fixture(:user) do
    card = insert(:card)
    library = insert(:library)
    {:ok, user} =
      params_for(:user)
      |> Enum.into(%{library_id: library.id, card_id: card.id})
      |> Account.create_user()
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      card = insert(:card)
      library = insert(:library)

      conn = post conn, user_path(conn, :create), user: Enum.into(@create_attrs, %{library_id: library.id, card_id: card.id})
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs

      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
