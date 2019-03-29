defmodule MetroWeb.BookViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.LayoutView
  import Phoenix.HTML, only: [safe_to_string: 1]

#  test "nav_link is not active when not on that page" do
#    link = LayoutView.nav_link(%{request_path: "/other_path"}, "Link text", "/path")
#           |> safe_to_string()
#    refute String.match? link, ~r/is-active/
#  end

  test "author_link is present when an author_id is filled in" do
#    link = LayoutView.nav_link(%{request_path: "/path"}, "Authors other works", "/author/show/")
#           |> safe_to_string()
#    assert String.match? link, ~r/is-active/
  end
end