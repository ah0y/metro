defmodule Metro.Factory do
  use ExMachina.Ecto, repo: Metro.Repo
  use Metro.BookFactory
  use Metro.AuthorFactory
  use Metro.CopyFactory
  use Metro.LibraryFactory
end