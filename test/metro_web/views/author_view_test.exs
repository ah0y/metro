defmodule MetroWeb.AuthorViewTest do
  use MetroWeb.ConnCase, async: true

  alias MetroWeb.AuthorView
  alias Metro.Repo
  alias Metro.Location.Book

  import Phoenix.View
  import Metro.Factory
  import Ecto.Query

  test "renders show.html", %{conn: conn} do
    author = build(:author)
             |> insert
             |> with_book

    author = Repo.preload(author, :books)

    page = Book
           |> where([b], b.author_id == ^author.id)
           |> Metro.Repo.paginate(page: 1)

    content = render_to_string(AuthorView, "show.html", page: page, books: page.entries, conn: conn, author: author)
    for book <- author.books do
      assert String.contains?(content, book.title)
    end
  end
end



