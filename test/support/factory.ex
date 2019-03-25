defmodule Metro.Factory do
  use ExMachina.Ecto, repo: Metro.Repo

  def book_factory do
    %Metro.Location.Book{
      title: "some title",
      image: "some image",
      isbn: 42,
      pages: 42,
      summary: "some summary",
      year: 42,
      author: build(:author)
    }
  end

  def author_factory do
    %Metro.Location.Author{
      bio: "some bio",
      first_name: "some first_name",
      last_name: "some last_name",
      location: "some location"
    }
  end
end