defmodule MetroWeb.BookApiView do
  use MetroWeb, :view
  alias MetroWeb.CopyApiView

  def render("index.json", %{books: books}) do
    %{
      books: Enum.map(books, &book_json/1)
    }
  end

  def book_json(book) do
    %{
      isbn: book.isbn,
      title: book.title,
      year: book.year,
      summary: book.summary,
      pages: book.pages,
      image: book.image
    }
  end

  def book_and_copies_json(book) do
    %{
      isbn: book.isbn,
      title: book.title,
      year: book.year,
      summary: book.summary,
      pages: book.pages,
      image: book.image,
      copies: render_many(book.copies, CopyApiView, "show.json", as: :copy)
    }
  end

  def render("show.json", %{book: book}) do
    %{book: book_and_copies_json(book)}
    end
end