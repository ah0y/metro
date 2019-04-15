defmodule Metro.CheckoutFactory do

  defmacro __using__(_opts) do
    quote do
      def checkout_factory do
        %Metro.Order.Checkout{
          checkout_date: ~N[2010-04-17 14:00:00.000000],
          due_date: ~N[2010-04-17 14:00:00.000000],
          renewals_remaining: 3,
          book: build(:book),
          library: build(:library),
          card: build(:card)
        }
      end
      def checkout_without_card_factory do
        %Metro.Order.Checkout{
          checkout_date: ~N[2010-04-17 14:00:00.000000],
          due_date: ~N[2010-04-17 14:00:00.000000],
          renewals_remaining: 3,
          book: build(:book),
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
          actual_arrival: ~N[2010-04-17 14:00:00.000000],
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
          position: 42,
          checkouts: build(:checkout),
        }
      end
    end
  end
end



