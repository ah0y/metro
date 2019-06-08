defmodule MetroWeb.CheckoutControllerTest do
  use MetroWeb.ConnCase

  alias Metro.Order
  alias Metro.Location

  import Metro.Factory

  alias Metro.Repo



  @create_attrs %{
    checkout_date: ~N[2010-04-17 14:00:00.000000],
    due_date: ~N[2010-04-17 14:00:00.000000],
    renewals_remaining: 42
  }
  @update_attrs %{
    checkout_date: ~N[2011-05-18 15:01:01.000000],
    due_date: ~N[2011-05-18 15:01:01.000000],
    renewals_remaining: 43
  }
  @invalid_attrs %{renewals_remaining: nil}

  def fixture(:checkout) do
    user = build(:user)
           |> insert
           |> with_card

    user = Metro.Repo.preload(user, [{:card, :checkouts}])

    library = insert(:library)
    book = build(:book)
           |> insert
           |> with_available_copies

    attr =
      string_params_for(:checkout)
      |> Enum.into(%{"library_id" => library.id, "isbn_id" => book.isbn, "card_id" => user.card.id})
    copy = Location.find_copy(book.isbn)
    trans = Order.create_order(user, attr, copy) #checks out out the only copy of a book to someone

    {:ok, %{checkout: checkout, reservation: _, transit: _, copy: _}} = trans
    checkout
  end

  describe "index" do
    setup do
      user = build(:admin)
             |> with_card
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(build_conn(), "/sessions", %{session: attrs})
      [conn: conn]
    end

    test "lists all checkouts", %{conn: conn} do
      conn = get conn, checkout_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Checkouts"
    end
  end

  describe "new checkout" do
    #    test "renders form only if you are authenticated and have a library card", %{conn: conn} do
    #      conn = get conn, checkout_path(conn, :new)
    #      assert html_response(conn, 200) =~ "New Checkout"
    #    end
    #    test "does not render form if you are authenticated without a library card", %{conn: conn} do
    #      conn = get conn, checkout_path(conn, :new)
    #      assert html_response(conn, 200) =~ "New Checkout"
    #    end
    #    test "does not render form if you are unauthenticated", %{conn: conn} do
    #      conn = get conn, checkout_path(conn, :new)
    #      assert html_response(conn, 200) =~ "New Checkout"
    #    end
  end

  describe "create checkout" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = build(:user)
             |> insert
             |> with_card
             |> Repo.preload([{:card, :checkouts}, :books])

      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(conn, session_path(conn, :create), %{session: attrs})

      conn = post conn,
                  checkout_path(conn, :create),
                  checkout: Enum.into(
                    @create_attrs,
                    %{
                      library_id: user.library.id,
                      card_id: user.card.id,
                      isbn_id: Enum.at(user.card.checkouts, 0).book.isbn
                    }
                  )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, user.id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = build(:user)
             |> insert
             |> with_card
             |> Repo.preload([{:card, :checkouts}, :books])

      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(conn, session_path(conn, :create), %{session: attrs})

      conn = post conn,
                  checkout_path(conn, :create),
                  checkout: Enum.into(
                    @invalid_attrs,
                    %{
                      library_id: user.library.id,
                      card_id: user.card.id,
                      isbn_id: Enum.at(user.card.checkouts, 0).book.isbn
                    }
                  )

      assert html_response(conn, 200) =~ "New Checkout"
    end
  end

  describe "edit checkout" do
    setup [:create_checkout]

    test "renders form for editing chosen checkout", %{conn: conn, checkout: checkout} do
      conn = get conn, checkout_path(conn, :edit, checkout)
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

  describe "update checkout" do
    setup [:create_checkout]

    test "redirects when data is valid", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :update, checkout), checkout: @update_attrs
      assert redirected_to(conn) == checkout_path(conn, :show, checkout)

      conn = get conn, checkout_path(conn, :show, checkout)
      assert html_response(conn, 200)
    end


    test "with empty checkout params, can check in a book", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :update, checkout)
      assert redirected_to(conn) == checkout_path(conn, :index)

      conn = get conn, checkout_path(conn, :show, checkout)
      assert html_response(conn, 200)
    end

    test "with empty checkout params, can check out a book", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :process, checkout)
      assert redirected_to(conn) == checkout_path(conn, :index)

      conn = get conn, checkout_path(conn, :show, checkout)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, checkout: checkout} do
      conn = put conn, checkout_path(conn, :update, checkout), checkout: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Checkout"
    end
  end

#  describe "delete checkout" do
#    setup [:create_checkout]
#
#    test "deletes chosen checkout", %{conn: conn, checkout: checkout} do
#      conn = delete conn, checkout_path(conn, :delete, checkout)
#      assert redirected_to(conn) == checkout_path(conn, :index)
#      assert_error_sent 404, fn ->
#        get conn, checkout_path(conn, :show, checkout)
#      end
#    end
#  end

  defp create_checkout(_) do
    user = build(:admin)
           |> with_card
    attrs = Map.take(user, [:email, :password_hash, :password])
    conn = post(build_conn(), "/sessions", %{session: attrs})
    checkout = fixture(:checkout)
    {:ok, conn: conn, checkout: checkout}
  end
end
