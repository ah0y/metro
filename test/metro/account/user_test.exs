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
        |> Account.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Account.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Account.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Account.create_card(@valid_attrs)
      assert card.pin == 42
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Account.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.pin == 43
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_card(card, @invalid_attrs)
      assert card == Account.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Account.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Account.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Account.change_card(card)
    end
  end
end
