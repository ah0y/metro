defmodule MetroWeb.CheckoutController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Checkout
  alias Metro.Account
  alias Metro.Location

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
    render(conn, "new.html", changeset: changeset, isbn: isbn, libraries: libraries )
  end

  def create(conn, %{"checkout" => checkout_params}) do
    card = Account.get_users_card!(conn.assigns.current_user.id)
    checkout_params = Enum.into(checkout_params, %{"card_id" => card.id})
    case Order.create_order(checkout_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Checkout created successfully.")
        |> redirect(to: book_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        libraries = Location.load_libraries()
        render(conn, "new.html", changeset: changeset, isbn: conn.assigns.isbn, card: card, libraries: libraries)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    render(conn, "show.html", checkout: checkout)
  end

  def edit(conn, %{"id" => id}) do
#    require IEx; IEx.pry()
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
        render(conn, "edit.html", checkout: checkout, changeset: changeset, isbn: checkout.isbn_id, libraries: libraries)
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
