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
  Gets a single checkout from a book copy.

  Raises `Ecto.NoResultsError` if the Checkout does not exist.

  ## Examples

      iex> get_copy_checkout!(123)
      %Checkout{}

      iex> get_copy_checkout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_copy_checkout!(copy), do: Repo.get_by!(Checkout, copy_id: copy)

  @doc """
  Determines whether or not a user can place a hold on a book.

  Raises `Ecto.NoResultsError` if the Checkout does not exist.

  ## Examples

      iex> can_checkout?(user)
      %Checkout{}

      iex> can_checkout?(user)
      ** (Ecto.NoResultsError)

  """
  def can_checkout?(user) do
#    require IEx; IEx.pry()
    cond do
      user.fines > 10 ->
        {:error, "user has unpaid library fines"}
      Enum.any?(
        user.card.checkouts,
        fn c -> c.checkin_date == nil and
                NaiveDateTime.compare(NaiveDateTime.utc_now(), c.due_date) == :gt
        end
      ) ->
        {:error, "user has an overdue book"}
      true -> {:ok, "can checkout"}
    end
  end

  @doc """
  Creates a checkout.

  ## Examples

      iex> create_checkout(%{field: value})
      {:ok, %Checkout{}}

      iex> create_checkout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkout(user, attrs, nil) do
    case can_checkout?(user) do
      {:ok, "can checkout"} ->
        %Checkout{}
        |> Checkout.changeset(Map.merge(%{"card_id" => user.card.id}, attrs))
        |> Repo.insert()
        {:error, error} ->
          {:error, error}
    end
  end

  def create_checkout(user, attrs, copy) do
    case can_checkout?(user) do
      {:ok, "can checkout"} ->
        %Checkout{}
        |> Checkout.changeset(
             Map.merge(
               attrs,
               %{
                 "card_id" => user.card.id,
                 "copy_id" => copy.id,
                 #             "checkout_date" => NaiveDateTime.utc_now(),
                 #             "due_date" => NaiveDateTime.add(NaiveDateTime.utc_now(), 2678400)
               }
             )
           )
        |> Repo.insert()
        {:error, error} ->
          {:error, error}
    end
  end

  alias Ecto.Query


  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Checkout{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(user, attr, nil) do
    order = Ecto.Multi.new

            |> Ecto.Multi.run(:checkout, fn _, _ -> Metro.Order.create_checkout(user, attr, nil) end)
            |> Ecto.Multi.run(
                 :transit,
                 fn _, %{checkout: checkout} -> Metro.Order.create_transit(%{checkout_id: checkout.id}) end
               )
            |> Ecto.Multi.run(
                 :reservation,
                 fn _, %{transit: transit} -> Metro.Order.create_reservation(%{transit_id: transit.id}) end
               )
            |> Ecto.Multi.run(
                 :waitlist,
                 fn _, %{checkout: checkout} ->
                   Metro.Order.create_waitlist(%{"checkout_id" => checkout.id, "isbn_id" => checkout.isbn_id})
                 end
               )
            |> Repo.transaction()
  end

  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Checkout{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(user, attr, book) do
    order = Ecto.Multi.new
            |> Ecto.Multi.run(:checkout, fn _, _ -> Metro.Order.create_checkout(user, attr, book) end)
            |> Ecto.Multi.run(
                 :copy,
                 fn _, _ -> Metro.Location.update_copy(book, %{checked_out?: true}) end
               )
            |> Ecto.Multi.run(
                 :transit,
                 fn _, %{checkout: checkout} -> Metro.Order.create_transit(checkout, book) end
               )
            |> Ecto.Multi.run(
                 :reservation,
                 fn _, %{transit: transit} -> Metro.Order.create_reservation(%{transit_id: transit.id}) end
               )
            |> Repo.transaction()
  end
  @doc """
  Checks in a book.

  ## Examples

      iex> check_in(%{field: value})
      {:ok, %Checkout{}}

      iex> check_in(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def check_in(copy) do
    check_in = Ecto.Multi.new
               |> Ecto.Multi.run(:copy, fn _, _ -> Metro.Location.update_copy(copy, %{checked_out?: false}) end)
               |> Ecto.Multi.run(
                    :checkout,
                    fn _, %{copy: copy} ->
                      Metro.Order.update_checkout(
                        Metro.Order.get_copy_checkout!(copy.id),
                        %{checkin_date: NaiveDateTime.utc_now(), copy_id: nil}
                      )
                    end
                  )
               |> Ecto.Multi.run(
                    :null_waitlist,
                    fn _, %{copy: copy} -> Metro.Order.null_waitlist_position(copy.id) end
                  )
               |> Ecto.Multi.run(
                    :next,
                    fn _, %{copy: copy} -> Metro.Order.first_in_line(copy.isbn_id) end
                  )
               |> Ecto.Multi.run(
                    :update_for_waiting,
                    fn _, %{next: next} -> Metro.Order.update_for_waiting(next, copy) end
                  )
               |> Ecto.Multi.run(
                    :decrement,
                    fn _, %{checkout: old_checkout} -> Metro.Order.decrement_waitlist(old_checkout.isbn_id) end
                  )
               |> Repo.transaction()

    #    IO.inspect(check_in)
  end

  @doc """
  Updates a copy and checkout of a book for those who are waiting.

  ## Examples

      iex> update_for_waiting(%{field: value})
      {:ok, %Checkout{}}

      iex> update_for_waiting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_for_waiting(next, copy) do
    case next do
      nil -> {:ok, nil}
      _ ->
        updates = Ecto.Multi.new
                  |> Ecto.Multi.run(
                       :update_checkout,
                       fn _, _ ->
                         Metro.Order.update_checkout(
                           Metro.Order.get_checkout!(next.checkout_id),
                           %{copy_id: copy.id}
                         )
                       end
                     )
                  |> Ecto.Multi.run(
                       :update_copy,
                       fn _, %{update_checkout: update_checkout} ->
                         Metro.Location.update_copy(
                           Metro.Location.get_copy!(copy.id),
                           %{
                             checked_out?: true,
                             #                             library_id: update_checkout.library_id
                           }
                         )
                       end
                     )
                  |> Repo.transaction()
        {:ok, updates}
    end
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
  Process a checkout.

  ## Examples

      iex> process_checkout(checkout, %{field: new_value})
      {:ok, %Checkout{}}

      iex> process_checkout(checkout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def process_checkout(%Checkout{} = checkout) do
    checkout
    |> Checkout.changeset(
         %{
           "checkout_date" => NaiveDateTime.utc_now(),
           "due_date" => NaiveDateTime.add(NaiveDateTime.utc_now(), 2678400)
         }
       )
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
    position = Metro.Order.next_in_line(Map.fetch!(attrs, "isbn_id"))
    %Waitlist{}
    |> Waitlist.changeset(Map.merge(attrs, %{"position" => position}))
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
  Updates a waitlist.

  ## Examples

      iex> null_waitlist_position(waitlist, %{field: new_value})
      {:ok, %Waitlist{}}

      iex> update_waitlist(waitlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def null_waitlist_position(copy_id) do
    #todo fix this mess lol
    waitlist = Repo.one(from w in Waitlist, where: w.copy_id == ^copy_id)
    unless waitlist == nil do
      waitlist
      |> Waitlist.changeset(%{position: nil})
      |> Repo.update()
    end
    {:ok, nil}
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

  @doc """
  Returns the next position in line for a book.
  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> next_in_line(123)
      %Book{}

      iex> next_in_line(456)
      ** (Ecto.NoResultsError)

  """
  def next_in_line(book_id) do
    position = Repo.one(
      from w in Waitlist, where: w.isbn_id == ^book_id and not (is_nil(w.position)), select: count(w.id)
    ) + 1
  end

  @doc """
  Returns the head of the waitlist for a certain book.
  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> first_in_line(123)
      %Book{}

      iex> first_in_line(456)
      ** (Ecto.NoResultsError)

  """
  def first_in_line(book_id) do
    #            waitlists = Repo.all(Waitlist)
    waitlist = Repo.one(
      from w in Waitlist, where: w.isbn_id == ^book_id and w.position == 1
    )
    {:ok, waitlist}
  end
  @doc """
  Decrements all non-null waitlist positions for a particular book
  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> decrement_waitlist(123)
      %Waitlist{}

      iex> decrement_waitlist(456)
      ** (Ecto.NoResultsError)

  """
  def decrement_waitlist(book_id) do
    from(
      w in Waitlist,
      where: w.isbn_id == ^book_id and not (is_nil(w.position)),
      update: [
        inc: [
          position: -1
        ]
      ]
    )
    |> Repo.update_all([])
    {:ok, nil}
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
    |> Repo.preload(:checkouts)
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

  def create_transit(checkout, copy) do
    copy_location = copy.library_id
    if checkout.library_id == copy_location do
      #pickup location is same as where the book actually is so number of days in transit == 1
      %Transit{}
      |> Transit.changeset(
           %{
             "copy_id" => copy.id,
             "checkout_id" => checkout.id,
             "estimated_arrival" => NaiveDateTime.add(NaiveDateTime.utc_now(), 86400)
           }
         )
      |> Repo.insert()
    else
      %Transit{}
      |> Transit.changeset(
           %{
             "copy_id" => copy.id,
             "checkout_id" => checkout.id,
             "estimated_arrival" => NaiveDateTime.add(NaiveDateTime.utc_now(), 259200)
           }
         )
      |> Repo.insert()
    end
  end

  def create_transit(attrs) do
    %Transit{}
    |> Transit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Completes a transit.

  ## Examples

      iex> complete_transit(transit, %{field: new_value})
      {:ok, %Transit{}}

      iex> complete_transit(transit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def complete_transit(transit, reservation) do
    completed_transit = Ecto.Multi.new
                        |> Ecto.Multi.run(
                             :transit,
                             fn
                               _, _ -> Metro.Order.update_transit(transit, %{actual_arrival: NaiveDateTime.utc_now()})
                             end
                           )
                        |> Ecto.Multi.run(
                             :reservation,
                             fn _, _ ->
                               Metro.Order.update_reservation(
                                 reservation,
                                 %{expiration_date: NaiveDateTime.add(NaiveDateTime.utc_now(), 432000)}
                               )
                             end
                           )
                        |> Repo.transaction()
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
  Gets a single reservation.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation_by_transit!(123)
      %Reservation{}

      iex> get_reservation_by_transit!(456)
      ** (Ecto.NoResultsError)

  """

  def get_reservation_by_transit!(transit), do: Repo.get_by!(Reservation, transit_id: transit)

  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_reservation(attrs) do
    %Reservation{}
    |> Reservation.changeset(attrs)
    |> Repo.insert()
  end

  #  def create_reservation(attrs, copy) do
  #      %Reservation{}
  #      |> Reservation.changeset(Map.merge(attrs, %{copy_id: copy.id}))
  #      |> Repo.insert()
  #  end

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