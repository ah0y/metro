defmodule MetroWeb.AuthorApiView do
  use MetroWeb, :view
  alias MetroWeb.BookApiView

  def author_json(author) do
    %{
      bio: author.bio,
      first_name: author.first_name,
      last_name: author.last_name,
      location: author.location,
      books: render_one(author.books, BookApiView, "index.json", as: :books )
    }
  end


  def render("show.json", %{author: author}) do
    %{author: author_json(author)}
  end
end