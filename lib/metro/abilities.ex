alias Metro.Account.{User, Card}
alias Metro.Order.{Checkout}
alias Metro.Repo

defimpl Canada.Can, for: User do

  def can?(%User{id: user_id_1, is_librarian?: true}, _, _), do: true

  def can?(%User{id: user_id_1}, action, %User{id: user_id_2})
      when action in [:show, :edit, :update, :delete] do
    user_id_1 == user_id_2
  end

  def can?(%User{id: user_id}, action, %Card{user_id: user_id})
      when action in [:show, :edit, :update, :delete] do
    true
  end

  def can?(user = %User{id: user_id}, _, Checkout)
    do
    user = user
           |> Repo.preload(:card)
    user.card != nil
  end

  def can?(%User{id: user_id}, _, _), do: true
end


