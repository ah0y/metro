defmodule Metro.Order do
  @moduledoc """
  The Order context.
  """

  import Ecto.Query, warn: false
  alias Metro.Repo

  alias Metro.Order.Checkout

  @doc """
  Returns the list of checkouts.

  ## Examples

      iex> list_checkouts()
      [%Checkout{}, ...]

  """
  def list_checkouts do
    Repo.all(Checkout)
  end

  @doc """
  Gets a single checkout.

  Raises `Ecto.NoResultsError` if the Checkout does not exist.

  ## Examples

      iex> get_checkout!(123)
      %Checkout{}

      iex> get_checkout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkout!(id), do: Repo.get!(Checkout, id)

  @doc """
  Creates a checkout.

  ## Examples

      iex> create_checkout(%{field: value})
      {:ok, %Checkout{}}

      iex> create_checkout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkout(attrs \\ %{}) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Checkout{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attr) do
      order = Ecto.Multi.new
      |> Ecto.Multi.run(:checkout, fn(_) -> create_checkout(attr) end)
      |> Ecto.Multi.run(:reservation, fn(%{checkout: checkout}) -> create_reservation(%{checkout_id: checkout.id}) end)
      |> Ecto.Multi.run(:transit, fn(%{checkout: checkout}) -> create_transit(checkout) end)
#      |> Ecto.Multi.run(:copy, fn(%{_})
      |> Repo.transaction()

#      case result do
#        {:ok, %{order: order}} ->
#          {:ok, Repo.preload(order, [:user, :line_items])}
#        {:error, :order, changeset, _} ->
#          {:error, changeset}
#      end
  end
  @doc """
  Updates a checkout.

  ## Examples

      iex> update_checkout(checkout, %{field: new_value})
      {:ok, %Checkout{}}

      iex> update_checkout(checkout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkout(%Checkout{} = checkout, attrs) do
    checkout
    |> Checkout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Checkout.

  ## Examples

      iex> delete_checkout(checkout)
      {:ok, %Checkout{}}

      iex> delete_checkout(checkout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkout(%Checkout{} = checkout) do
    Repo.delete(checkout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkout changes.

  ## Examples

      iex> change_checkout(checkout)
      %Ecto.Changeset{source: %Checkout{}}

  """
  def change_checkout(%Checkout{} = checkout) do
    Checkout.changeset(checkout, %{})
  end

  alias Metro.Order.Waitlist

  @doc """
  Returns the list of waitlist.

  ## Examples

      iex> list_waitlist()
      [%Waitlist{}, ...]

  """
  def list_waitlist do
    Repo.all(Waitlist)
  end

  @doc """
  Gets a single waitlist.

  Raises `Ecto.NoResultsError` if the Waitlist does not exist.

  ## Examples

      iex> get_waitlist!(123)
      %Waitlist{}

      iex> get_waitlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_waitlist!(id), do: Repo.get!(Waitlist, id)

  @doc """
  Creates a waitlist.

  ## Examples

      iex> create_waitlist(%{field: value})
      {:ok, %Waitlist{}}

      iex> create_waitlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_waitlist(attrs \\ %{}) do
    %Waitlist{}
    |> Waitlist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a waitlist.

  ## Examples

      iex> update_waitlist(waitlist, %{field: new_value})
      {:ok, %Waitlist{}}

      iex> update_waitlist(waitlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_waitlist(%Waitlist{} = waitlist, attrs) do
    waitlist
    |> Waitlist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Waitlist.

  ## Examples

      iex> delete_waitlist(waitlist)
      {:ok, %Waitlist{}}

      iex> delete_waitlist(waitlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_waitlist(%Waitlist{} = waitlist) do
    Repo.delete(waitlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking waitlist changes.

  ## Examples

      iex> change_waitlist(waitlist)
      %Ecto.Changeset{source: %Waitlist{}}

  """
  def change_waitlist(%Waitlist{} = waitlist) do
    Waitlist.changeset(waitlist, %{})
  end

  alias Metro.Order.Transit

  @doc """
  Returns the list of transit.

  ## Examples

      iex> list_transit()
      [%Transit{}, ...]

  """
  def list_transit do
    Repo.all(Transit)
  end

  @doc """
  Gets a single transit.

  Raises `Ecto.NoResultsError` if the Transit does not exist.

  ## Examples

      iex> get_transit!(123)
      %Transit{}

      iex> get_transit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transit!(id), do: Repo.get!(Transit, id)

  @doc """
  Creates a transit.

  ## Examples

      iex> create_transit(%{field: value})
      {:ok, %Transit{}}

      iex> create_transit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transit(attrs \\ %{}) do
    %Transit{}
    |> Transit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transit.

  ## Examples

      iex> update_transit(transit, %{field: new_value})
      {:ok, %Transit{}}

      iex> update_transit(transit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transit(%Transit{} = transit, attrs) do
    transit
    |> Transit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transit.

  ## Examples

      iex> delete_transit(transit)
      {:ok, %Transit{}}

      iex> delete_transit(transit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transit(%Transit{} = transit) do
    Repo.delete(transit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transit changes.

  ## Examples

      iex> change_transit(transit)
      %Ecto.Changeset{source: %Transit{}}

  """
  def change_transit(%Transit{} = transit) do
    Transit.changeset(transit, %{})
  end

  alias Metro.Order.Reservation

  @doc """
  Returns the list of reservations.

  ## Examples

      iex> list_reservations()
      [%Reservation{}, ...]

  """
  def list_reservations do
    Repo.all(Reservation)
  end

  @doc """
  Gets a single reservation.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation!(123)
      %Reservation{}

      iex> get_reservation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reservation!(id), do: Repo.get!(Reservation, id)

  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reservation(attrs \\ %{}) do
    %Reservation{}
    |> Reservation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reservation.

  ## Examples

      iex> update_reservation(reservation, %{field: new_value})
      {:ok, %Reservation{}}

      iex> update_reservation(reservation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reservation(%Reservation{} = reservation, attrs) do
    reservation
    |> Reservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reservation.

  ## Examples

      iex> delete_reservation(reservation)
      {:ok, %Reservation{}}

      iex> delete_reservation(reservation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reservation(%Reservation{} = reservation) do
    Repo.delete(reservation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reservation changes.

  ## Examples

      iex> change_reservation(reservation)
      %Ecto.Changeset{source: %Reservation{}}

  """
  def change_reservation(%Reservation{} = reservation) do
    Reservation.changeset(reservation, %{})
  end
end
