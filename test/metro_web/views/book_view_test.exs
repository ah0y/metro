defmodule MetroWeb.BookViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.LayoutView
  alias MetroWeb.BookView
  alias Metro.Repo
  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Metro.Factory
  @moduletag book_view_case: "book views"

  describe "show.html" do
    test "shows Unavailable for books without available copies", %{conn: conn} do
      book = build(:book)
             |> insert
             |> with_unavailable_copies

      book = Repo.preload(book, :copies)

      content = render_to_string(BookView, "show.html", conn: conn, book: book)
      occurences =
        content
        |> String.split("UNAVAILABLE")
        |> length()

      assert occurences == 2
    end
  end
end



