defmodule Metro.OrderTest do
  use Metro.DataCase

  alias Metro.Order
  alias Metro.Location

  import Metro.Factory

  describe "checkouts" do
    alias Metro.Order.Checkout

    @valid_attrs %{
      checkout_date: ~N[2010-04-17 14:00:00.000000],
      due_date: ~N[2010-04-17 14:00:00.000000],
      renewals_remaining: 3
    }
    @update_attrs %{
      checkout_date: ~N[2011-05-18 15:01:01.000000],
      due_date: ~N[2011-05-18 15:01:01.000000],
      renewals_remaining: 4
    }
    @invalid_attrs %{checkout_date: nil, due_date: nil, renewals_remaining: nil, isbn_id: nil}

    def checkout_fixture(_attrs \\ %{}) do
      card = insert(:card)
      library = insert(:library)
      book = insert(:book)
      {:ok, checkout} =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})
        |> Order.create_checkout()
      checkout
    end

    test "list_checkouts/0 returns all checkouts" do
      checkout = checkout_fixture()
      assert Order.list_checkouts() == [checkout]
    end

    test "get_copy_checkout!/1 returns the checkout with given copy id" do
      card = insert(:card)
      library = insert(:library)
      book = build(:book)
             |> insert
             |> with_available_copies

      attr =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})
      copy = Location.find_copy(book.isbn)
      trans = Order.create_order(attr, copy)

      assert {
               :ok,
               %{
                 checkout: %Metro.Order.Checkout{
                   id: checkout_id
                 },
                 transit: %Metro.Order.Transit{
                   checkout_id: checkout_id
                 },

                 reservation: %Metro.Order.Reservation{
                   transit_id: transit_id

                 },
                 copy: %Metro.Location.Copy{
                   checked_out?: true
                 }
               }
             } = trans
            {:ok, %{checkout: checkout, reservation: reservation, transit: transit, copy: copy}} = trans
      assert Order.get_copy_checkout!(copy.id).id == checkout.id
    end

    test "get_checkout!/1 returns the checkout with given id" do
      checkout = build(:checkout)
                 |> insert
      assert Order.get_checkout!(checkout.id).id == checkout.id
    end

#    @tag multi: "order"
    test "create_order/2 with valid data creates a checkout, transit, and reservation if there's an available copy" do
      card = insert(:card)
      library = insert(:library)
      book = build(:book)
             |> insert
             |> with_available_copies

      attr =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})
      copy = Location.find_copy(book.isbn)
      trans = Order.create_order(attr, copy)

      assert {
               :ok,
               %{
                 checkout: %Metro.Order.Checkout{
                   id: checkout_id
                 },
                 transit: %Metro.Order.Transit{
                   checkout_id: checkout_id
                 },

                 reservation: %Metro.Order.Reservation{
                   transit_id: transit_id

                 },
                 copy: %Metro.Location.Copy{
                   checked_out?: true
                 }
               }
             } = trans
      #      {:ok, %{checkout: checkout, reservation: reservation, transit: transit, copy: copy}} = trans
    end

    @tag multi: "order"
    test "create_order/2 with valid data creates a checkout, reservation, transit, and waitlist if there's not an available copy" do
      card = insert(:card)
      library = insert(:library)
      book = build(:book)
             |> insert
             |> with_unavailable_copies

      attr =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})

      trans = Order.create_order(attr)

      assert {
               :ok,
               %{
                 checkout: %Metro.Order.Checkout{
                   id: checkout_id
                 },
                 transit: %Metro.Order.Transit{
                   checkout_id: checkout_id
                 },

                 reservation: %Metro.Order.Reservation{
                   transit_id: transit_id

                 },
                 waitlist: %Metro.Order.Waitlist{
                   checkout_id: checkout_id,
                    position: 1
                 }
               }
             } = trans
      #      {:ok, %{checkout: checkout, reservation: reservation, transit: transit, copy: copy}} = trans
    end

    @tag multi: "order"
    test "check_in/1 with valid data decremetes the position of everyone on the waitlist for a copy of a book, updates the availabaility of a book, " do
      card = insert(:card)
      library = insert(:library)
      book = build(:book)
             |> insert
             |> with_available_copies

      attr =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})
      copy = Location.find_copy(book.isbn)
      trans = Order.create_order(attr, copy) #checks out out the only copy of a book to someone

      {:ok, %{checkout: checkout, reservation: reservation, transit: transit, copy: copy}} = trans

      copy_id = copy.id

      card2 = insert(:card)

      attr2 =
        params_for(:checkout)
        |> Enum.into(%{library_id: library.id, isbn_id: book.isbn, card_id: card.id})

      trans2 = Order.create_order(attr) #puts someone at position 1 for a book that's already checked out

      assert {
               :ok,
               %{
                 checkout: %Metro.Order.Checkout{
#                   id: checkout_id
                 },
                 transit: %Metro.Order.Transit{
#                   checkout_id: checkout_id
                 },

                 reservation: %Metro.Order.Reservation{
#                   transit_id: transit_id

                 },
                 waitlist: %Metro.Order.Waitlist{
                   checkout_id: checkout_id,
                    position: 1,
                    copy_id: nil
                 }
               }
             } = trans2
#      {:ok, %{checkout: checkout2, reservation: reservation2, transit: transit2, waitlist: waitlist}} = trans2

      trans3 = Order.check_in(copy)

            assert {
                     :ok,
                     %{
                       copy: %Metro.Location.Copy{
                         checked_out?: false
                       },
                       checkout: %Metro.Order.Checkout{
                         checkin_date: not(is_nil)
                       },
#
#                       reservation: %Metro.Order.Reservation{
#                         transit_id: transit_id
#
#                       },
                       waitlist: %Metro.Order.Waitlist{
                         checkout_id: checkout_id,
                          position: nil,
                          copy_id: copy_id
                       }
                     }
                   } = trans3

#      {:ok, %{checkout: checkout2, reservation: reservation2, transit: transit2, waitlist: waitlist}} = trans2
    end



    test "create_checkout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Order.create_checkout(@invalid_attrs)
    end

    test "update_checkout/2 with valid data updates the checkout" do
      checkout = checkout_fixture()
      assert {:ok, checkout} = Order.update_checkout(checkout, @update_attrs)
      assert %Checkout{} = checkout
      assert checkout.checkout_date == ~N[2011-05-18 15:01:01.000000]
      assert checkout.due_date == ~N[2011-05-18 15:01:01.000000]
      assert checkout.renewals_remaining == 4
    end

    test "update_checkout/2 with invalid data returns error changeset" do
      checkout = checkout_fixture()
      assert {:error, %Ecto.Changeset{}} = Order.update_checkout(checkout, @invalid_attrs)
      assert checkout == Order.get_checkout!(checkout.id)
    end

    test "delete_checkout/1 deletes the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{}} = Order.delete_checkout(checkout)
      assert_raise Ecto.NoResultsError, fn -> Order.get_checkout!(checkout.id) end
    end

    test "change_checkout/1 returns a checkout changeset" do
      checkout = checkout_fixture()
      assert %Ecto.Changeset{} = Order.change_checkout(checkout)
    end
  end

  describe "waitlist" do
    alias Metro.Order.Waitlist

    @valid_attrs %{position: 42}
    @update_attrs %{position: 43}
    @invalid_attrs %{position: nil, copy_id: nil, checkout_id: nil}

    def waitlist_fixture(attrs \\ %{}) do
      waitlist = insert(:waitlist)
    end

    test "list_waitlist/0 returns all waitlist" do
      waitlist = waitlist_fixture()
      waitlist = Unpreloader.forget(waitlist, :checkouts)
      assert Order.list_waitlist() == [waitlist]
    end

    test "get_waitlist!/1 returns the waitlist with given id" do
      waitlist = waitlist_fixture()
      waitlist = Unpreloader.forget(waitlist, :checkouts)
      assert Order.get_waitlist!(waitlist.id) == waitlist
    end

    test "create_waitlist/1 with valid data creates a waitlist" do
      checkout = insert(:checkout)
      attrs = params_for(:waitlist)
              |> Enum.into(%{checkout_id: checkout.id})
      assert {:ok, %Waitlist{} = waitlist} = Order.create_waitlist(attrs)
      assert waitlist.position == 42
    end

    test "create_waitlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Order.create_waitlist(@invalid_attrs)
    end

    test "update_waitlist/2 with valid data updates the waitlist" do
      waitlist = waitlist_fixture()
      assert {:ok, waitlist} = Order.update_waitlist(waitlist, @update_attrs)
      assert %Waitlist{} = waitlist
      assert waitlist.position == 43
    end

    test "update_waitlist/2 with invalid data returns error changeset" do
      waitlist = waitlist_fixture()
      assert {:error, %Ecto.Changeset{}} = Order.update_waitlist(waitlist, @invalid_attrs)
      waitlist = Unpreloader.forget(waitlist, :checkouts)
      assert waitlist == Order.get_waitlist!(waitlist.id)
    end

    test "delete_waitlist/1 deletes the waitlist" do
      waitlist = waitlist_fixture()
      assert {:ok, %Waitlist{}} = Order.delete_waitlist(waitlist)
      assert_raise Ecto.NoResultsError, fn -> Order.get_waitlist!(waitlist.id) end
    end

    test "change_waitlist/1 returns a waitlist changeset" do
      waitlist = waitlist_fixture()
      assert %Ecto.Changeset{} = Order.change_waitlist(waitlist)
    end


    @tag waitlist: "line"
    test "next_in_line/1 returns 1 if there are no other people in line for the book" do
      book = build(:book)
             |> insert
             |> with_available_copies
      assert Order.next_in_line(book.isbn) == 1
    end

    @tag waitlist: "line"
    test "next_in_line/1 returns 1 if all other waitlist entries for a book have a position of nil" do
      book = build(:book)
             |> insert
             |> with_available_copies
             |> with_waitlist_nil

      assert Order.next_in_line(book.isbn) == 1
    end

    @tag waitlist: "line"
    test "next_in_line/1 returns 2 if there is someone else in line for the book" do
      book = build(:book)
             |> insert
             |> with_available_copies
             |> with_waitlist

      assert Order.next_in_line(book.isbn) == 2
    end

    @tag waitlist: "line"
    test "decrement_waitlist/1 reduces the position of all non null waitlist entries for a book by 1" do
      book = build(:book)
             |> insert
             |> with_available_copies
             |> with_waitlist

      waitlists_before = Repo.all(Waitlist)

      Order.decrement_waitlist(book.id)

      Enum.all?(waitlists_before, fn x ->
        Repo.one(from w in Waitlist, where x.id == ^w.id) == nil
        or
        x.position - 1  == Repo.one(from w in Waitlist, where x.id == ^w.id)
      end)
    end
  end

  describe "transit" do
    alias Metro.Order.Transit

    import Metro.Factory

    @valid_attrs %{actual_arrival: ~N[2010-04-17 14:00:00.000000], estimated_arrival: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{actual_arrival: ~N[2011-05-18 15:01:01.000000], estimated_arrival: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{actual_arrival: nil, estimated_arrival: nil, checkout_id: nil}

    def transit_fixture(attrs \\ %{}) do
      transit = insert(:transit)
    end

    test "list_transit/0 returns all transit" do
      transit = transit_fixture()
      transit = Unpreloader.forget(transit, :checkouts)
      assert Order.list_transit() == [transit]
    end

    test "get_transit!/1 returns the transit with given id" do
      transit = transit_fixture()
      transit = Unpreloader.forget(transit, :checkouts)
      assert Order.get_transit!(transit.id) == transit
    end

    test "create_transit/1 with valid data creates a transit" do
      checkout = insert(:checkout)
      attrs = params_for(:transit)
              |> Enum.into(%{checkout_id: checkout.id})
      assert {:ok, %Transit{} = transit} = Order.create_transit(attrs)
      assert transit.actual_arrival == ~N[2010-04-17 14:00:00.000000]
      assert transit.estimated_arrival == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_transit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Order.create_transit(@invalid_attrs)
    end

    test "update_transit/2 with valid data updates the transit" do
      transit = transit_fixture()
      assert {:ok, transit} = Order.update_transit(transit, @update_attrs)
      assert %Transit{} = transit
      assert transit.actual_arrival == ~N[2011-05-18 15:01:01.000000]
      assert transit.estimated_arrival == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_transit/2 with invalid data returns error changeset" do
      transit = transit_fixture()
      assert {:error, %Ecto.Changeset{}} = Order.update_transit(transit, @invalid_attrs)
      transit = Unpreloader.forget(transit, :checkouts)
      assert transit == Order.get_transit!(transit.id)
    end

    test "delete_transit/1 deletes the transit" do
      transit = transit_fixture()
      assert {:ok, %Transit{}} = Order.delete_transit(transit)
      assert_raise Ecto.NoResultsError, fn -> Order.get_transit!(transit.id) end
    end

    test "change_transit/1 returns a transit changeset" do
      transit = transit_fixture()
      assert %Ecto.Changeset{} = Order.change_transit(transit)
    end
  end

  describe "reservations" do
    alias Metro.Order.Reservation

    @valid_attrs %{expiration_date: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{expiration_date: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{expiration_date: nil}

    def reservation_fixture(attrs \\ %{}) do
      reservation = insert(:reservation)
    end

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      reservation = Unpreloader.forget(reservation, :transit)
      assert Order.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      reservation = Unpreloader.forget(reservation, :transit)
      assert Order.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data creates a reservation" do
      transit = insert(:transit)
      attrs = params_for(:reservation)
              |> Enum.into(%{transit_id: transit.id})
      assert {:ok, %Reservation{} = reservation} = Order.create_reservation(attrs)
      assert reservation.expiration_date == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Order.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()
      assert {:ok, reservation} = Order.update_reservation(reservation, @update_attrs)
      assert %Reservation{} = reservation
      assert reservation.expiration_date == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()
      assert {:error, %Ecto.Changeset{}} = Order.update_reservation(reservation, @invalid_attrs)
      reservation = Unpreloader.forget(reservation, :transit)
      assert reservation == Order.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = Order.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> Order.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = Order.change_reservation(reservation)
    end
  end
end

defmodule Unpreloader do
  def forget(struct, field, cardinality \\ :one) do
    %{
      struct |
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end
end
