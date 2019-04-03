defmodule MetroWeb.CheckoutViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.CheckoutView
  alias Metro.Repo

  import Phoenix.View
  import Metro.Factory

  describe "show.html" do
    test "shows link to either sign in or enter in library card info if a user isn't authenticated", %{conn: conn} do

    end

    test "doesn't show link to either sign in or enter in library card info if a user is authenticated", %{conn: conn} do
      user = build(:user)
             |> insert
             |> with_card
             |> Repo.preload(:card)
      attrs = Map.take(user, [:email, :password_hash, :password])
      conn = post(conn, session_path(conn, :create), %{session: attrs})
      assert 1 == 2
    end
  end
end



