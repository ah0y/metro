defmodule Metro.UserFactory do

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Metro.Account.User{
          name: "some user",
          email: sequence(:email, &"me-#{&1}@foo.com"),
          password: "password",
          password_hash: "$2b$12$XLGRLrhRbzLiicATx7Zihe2hXdqrkpbN4cSwD.w0e/LpZtvh.TkcS",
          fines: 0.00,
          num_books_out: 0,
          is_librarian?: false,
          library: build(:library),
        }
      end

      def admmin_factory do
        %Metro.Account.User{
          name: "some user",
          email: sequence(:email, &"me-#{&1}@foo.com"),
          password: "password",
          password_hash: "$2b$12$XLGRLrhRbzLiicATx7Zihe2hXdqrkpbN4cSwD.w0e/LpZtvh.TkcS",
          fines: 0.00,
          num_books_out: 0,
          is_librarian?: true,
          library: build(:library),
        }
      end

      def user_with_fines_factory do
        %Metro.Account.User{
          name: "some user",
          email: sequence(:email, &"me-#{&1}@foo.com"),
          password: "password",
          password_hash: "$2b$12$XLGRLrhRbzLiicATx7Zihe2hXdqrkpbN4cSwD.w0e/LpZtvh.TkcS",
          fines: 11.00,
          num_books_out: 0,
          is_librarian?: false,
          library: build(:library),
        }
      end

      def with_card(%Metro.Account.User{} = user) do
        insert(:card_without_user, user: user)
        user
      end

      def with_card_and_overdue(%Metro.Account.User{} = user) do
        insert(:card_with_overdue_checkouts, user: user)
        user
      end
    end
  end
end


defmodule Metro.CardFactory do

  defmacro __using__(_opts) do
    quote do
      def card_factory do
        %Metro.Account.Card{
          user: build(:user),
          pin: "0123",
        }
      end

      def card_with_fines_factory do
        %Metro.Account.Card{
          user: build(:user_with_fines),
          pin: "0123",
        }
      end

      def card_without_user_factory do
        %Metro.Account.Card{
          pin: "0123",
          checkouts: [build(:checkout_without_card)]
        }
      end



      def card_with_overdue_checkouts_factory do
        %Metro.Account.Card{
          pin: "0123",
          checkouts: [build(:overdue_checkout_without_card)]
        }
      end
    end
  end
end



