defmodule Metro.AccountTest do
  use Metro.DataCase

  alias Metro.Account

  import Metro.Factory

  describe "cards" do
    alias Metro.Account.Card

    @valid_attrs %{pin: "42"}
    @update_attrs %{pin: "43"}
    @invalid_attrs %{pin: nil}

    def card_fixture(attrs \\ %{}) do
      card = insert(:card)
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Enum.at(Account.list_cards(), 0).id == card.id
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Account.get_card!(card.id).id == card.id
    end

    test "create_card/1 with valid data creates a card" do
      user = insert(:user)
      assert {:ok, %Card{} = card} = Account.create_card(Enum.into(@valid_attrs, %{user_id: user.id}))
      assert card.pin == "42"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Account.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.pin == "43"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_card(card, @invalid_attrs)
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
