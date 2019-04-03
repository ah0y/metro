alias Metro.Account.{User, Card}

defimpl Canada.Can, for: User do
  def can?(%User{id: user_id_1}, action, %User{id: user_id_2})
      when action in [:edit, :update, :delete] do
      user_id_1 == user_id_2
  end


  def can?(_, _, _), do: true
end