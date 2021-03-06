defmodule Metro.CheckoutFactory do

  defmacro __using__(_opts) do
    quote do
      def checkout_factory do
        %Metro.Order.Checkout{
#          checkout_date: ~N[2010-04-17 14:00:00.000000],
#          due_date: ~N[2010-04-17 14:00:00.000000],
          renewals_remaining: 3,
          book: build(:book),
          library: build(:library),
          card: build(:card)
        }
      end
      def with_book_and_copy(%Metro.Order.Checkout{} = checkout) do
        book = build(:book)
               |> insert
               |> with_available_copies
        build(book, checkout: checkout)
        checkout
      end
      def checkout_without_card_factory do
        %Metro.Order.Checkout{
          checkout_date: ~N[2024-04-17 14:00:00.000000],
          due_date: ~N[2024-05-17 14:00:00.000000],
          renewals_remaining: 3,
          book: build(:book),
          library: build(:library),
        }
      end
      def overdue_checkout_without_card_factory do
        %Metro.Order.Checkout{
          checkout_date: NaiveDateTime.utc_now(),
          checkin_date: nil,
          due_date: NaiveDateTime.add(NaiveDateTime.utc_now(), -86400),
          renewals_remaining: 3,
          library: build(:library),
        }
      end
    end
  end
end

defmodule Metro.ReservationFactory do

  defmacro __using__(_opts) do
    quote do
      def reservation_factory do
        %Metro.Order.Reservation{
          expiration_date: ~N[2010-04-17 14:00:00.000000],
          transit: build(:transit),
        }
      end
    end
  end
end


defmodule Metro.TransitFactory do

  defmacro __using__(_opts) do
    quote do
      def transit_factory do
        %Metro.Order.Transit{
#          actual_arrival: ~N[2010-04-17 14:00:00.000000],
          estimated_arrival: ~N[2010-04-17 14:00:00.000000],
          checkouts: build(:checkout),
        }
      end
    end
  end
end

defmodule Metro.WaitlistFactory do

  defmacro __using__(_opts) do
    quote do
      def waitlist_factory do
        %Metro.Order.Waitlist{
          position: 2,
          book: build(:book),
        }
      end

      def waitlist_without_book_factory do
        %Metro.Order.Waitlist{
          position: 2,
        }
      end

      def waitlist_with_nil_factory do
        %Metro.Order.Waitlist{
          position: nil,
          book: build(:book),
        }
      end
    end
  end
end



