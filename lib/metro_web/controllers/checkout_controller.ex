defmodule MetroWeb.CheckoutController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Checkout
  alias Metro.Account
  alias Metro.Location
  alias Metro.Repo

  #  plug :load_and_authorize_resource, model: Metro.Order.Checkout
  #  use MetroWeb.ControllerAuthorization

  def index(conn, _params) do
    checkouts = Order.list_checkouts()
    render(conn, "index.html", checkouts: checkouts)
  end

  def new(conn, _params) do
    {_, ref_url} = List.keyfind(conn.req_headers, "referer", 0)
    isbn = Enum.at(Regex.run(~r/\d*$/, ref_url), 0)
    conn = assign(conn, :isbn, isbn)
    libraries = Location.load_libraries()

    changeset = Order.change_checkout(%Checkout{})
    render(conn, "new.html", changeset: changeset, isbn: isbn, libraries: libraries)
  end

  def create(conn, %{"checkout" => checkout_params}) do
    card = Account.get_users_card!(conn.assigns.current_user.id)
    checkout_params = Enum.into(checkout_params, %{"card_id" => card.id})
    copy = Location.find_copy(Map.get(checkout_params, "isbn_id"))
    case Order.create_order(checkout_params, copy) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Checkout created successfully.")
        |> redirect(to: user_path(conn, :show, conn.assigns.current_user.id))
      {:error, :checkout, %Ecto.Changeset{} = changeset, %{}} ->
        libraries = Location.load_libraries()
        render(conn, "new.html", changeset: changeset, isbn: Map.get(changeset.changes, :isbn_id ), card: card, libraries: libraries)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    render(conn, "show.html", checkout: checkout)
  end

  def edit(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    changeset = Order.change_checkout(checkout)
    libraries = Location.load_libraries()
    render(conn, "edit.html", checkout: checkout, changeset: changeset, isbn: checkout.isbn_id, libraries: libraries)
  end

  def update(conn, %{"id" => id, "checkout" => checkout_params}) do
    checkout = Order.get_checkout!(id)
    libraries = Location.load_libraries()
    case Order.update_checkout(checkout, checkout_params) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout updated successfully.")
        |> redirect(to: checkout_path(conn, :show, checkout))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          checkout: checkout,
          changeset: changeset,
          isbn: checkout.isbn_id,
          libraries: libraries
        )
    end
  end

  def update(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
      |> Repo.preload(:copy)
    require IEx; IEx.pry()
    case Order.check_in(checkout.copy) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout updated successfully.")
        |> redirect(to: checkout_path(conn, :index))
      {:error, _} ->
        IO.puts("error")
    end
  end

  def delete(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    {:ok, _checkout} = Order.delete_checkout(checkout)

    conn
    |> put_flash(:info, "Checkout deleted successfully.")
    |> redirect(to: checkout_path(conn, :index))
  end
end
