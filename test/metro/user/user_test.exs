defmodule Metro.AccountTest do
  use Metro.DataCase

  alias Metro.Account

  describe "cards" do
    alias Metro.Account.Card

    @valid_attrs %{pin: 42}
    @update_attrs %{pin: 43}
    @invalid_attrs %{pin: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert User.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert User.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = User.create_card(@valid_attrs)
      assert card.pin == 42
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = User.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.pin == 43
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_card(card, @invalid_attrs)
      assert card == User.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = User.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> User.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = User.change_card(card)
    end
  end
end
