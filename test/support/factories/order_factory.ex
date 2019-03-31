defmodule Metro.CheckoutFactory do

  defmacro __using__(_opts) do
    quote do
      def checkout_factory do
        %Metro.Order.Checkout{
          checkout_date: ~N[2010-04-17 14:00:00.000000],
          due_date: ~N[2010-04-17 14:00:00.000000],
        }
      end

      def with_library(%Metro.Order.Checkout{} = checkout) do
        insert(:library, checkout: checkout)
        checkout
      end

      def with_card(%Metro.Order.Checkout{} = checkout) do
        insert(:card, checkout: checkout)
        checkout
      end

      def with_book(%Metro.Order.Checkout{} = checkout) do
        insert(:book, checkout: checkout)
        checkout
      end
    end
  end
end

