defmodule Metro.Notification.Notification do

  import Ecto.Query, warn: false
  alias Metro.Repo

  alias Metro.Notification.Alert

  @doc """
  Returns the first 10 notifications of a user.

  ## Examples

      iex> list_checkouts()
      [%Checkout{}, ...]

  """
  def for(user_id) do
    query = from(a in Alert, where: a.notifier_id == ^user_id, limit: 10)
    Repo.all(query)
  end
end