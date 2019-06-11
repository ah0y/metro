alias Metro.Account.{User, Card}
alias Metro.Order.{Checkout, Waitlist, Transit, Reservation}
alias Metro.Location.{Book, Library, Copy, Author}
alias Metro.Repo

defimpl Canada.Can, for: User do

  def can?(%User{id: user_id_1, is_librarian?: true}, _, _), do: true

  def can?(%User{}, :show, %Book{}), do: true
  def can?(%User{}, :index, Book), do: true

  def can?(%User{}, :show, %Library{}), do: true
  def can?(%User{}, :index, Library), do: true

  def can?(%User{}, :show, %Author{}), do: true
  def can?(%User{}, :index, Author), do: true

  def can?(%User{id: user_id_1}, action, %User{id: user_id_2})
      when action in [:show] do
    user_id_1 == user_id_2
  end

  def can?(%User{id: user_id}, action, %Card{user_id: user_id})
      when action in [:show, :edit, :update, :delete] do
    true
  end

  def can?(user = %User{id: user_id}, action, Checkout)
      when action in [:new, :create] do
    user = user
           |> Repo.preload(:card)

    user.card != nil
  end

  def can?(%User{}, action, Card)
      when action in [:new, :create] do
    true
  end

  def can?(%User{}, _, _), do: false
end

defimpl Canada.Can, for: Atom do
  def can?(nil, :show, %Book{}), do: true
  def can?(nil, :index, Book), do: true

  def can?(nil, :show, %Library{}), do: true
  def can?(nil, :index, Library), do: true

  def can?(nil, :show, %Author{}), do: true
  def can?(nil, :index, Author), do: true

  def can?(nil, _, _), do: false
end

