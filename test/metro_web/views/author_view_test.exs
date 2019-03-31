defmodule MetroWeb.AuthorViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.LayoutView
  alias MetroWeb.AuthorView
  alias Metro.Repo
  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Metro.Factory
  @moduletag author_view_case: "author views"

  test "renders show.html", %{conn: conn} do
    author = build(:author)
             |> insert
             |> with_book

    author = Repo.preload(author, :books)

    content = render_to_string(AuthorView, "show.html", conn: conn, author: author)
    for book <- author.books do
      assert String.contains?(content, book.title)
    end
  end
end



