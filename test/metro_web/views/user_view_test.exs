defmodule MetroWeb.UserViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.UserView
  alias Metro.Repo

  import Phoenix.View
  import Metro.Factory

  describe "show.html" do
    test "shows link to card/new if the user has no card", %{conn: conn} do
      user = insert(:user)
            |> Repo.preload(:card)
      content = render_to_string(UserView, "show.html", conn: conn, user: user)
      assert String.contains?(content, "sign up for a new card") == true
    end

    test "doesn't show link to card/new if the user has a card", %{conn: conn} do
      user = build(:user)
          |> insert
          |> with_card
          |> Repo.preload(:card)
      content = render_to_string(UserView, "show.html", conn: conn, user: user)
      assert String.contains?(content, "sign up for a new card") == false
    end
  end
end



