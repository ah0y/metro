defmodule Metro.Factory do
  use ExMachina.Ecto, repo: Metro.Repo
  use Metro.BookFactory
  use Metro.AuthorFactory
  use Metro.CopyFactory
  use Metro.LibraryFactory
  use Metro.CheckoutFactory
  use Metro.UserFactory
  use Metro.CardFactory
  use Metro.ReservationFactory
  use Metro.TransitFactory
  use Metro.WaitlistFactory
end