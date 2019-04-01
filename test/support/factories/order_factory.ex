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
          card: build(:card_without_checkouts)
        }
      end
    end
  end
end

