defmodule MetroWeb.CheckoutController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Checkout

  def index(conn, _params) do
    checkouts = Order.list_checkouts()
    render(conn, "index.html", checkouts: checkouts)
  end

  def new(conn, _params) do
    changeset = Order.change_checkout(%Checkout{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"checkout" => checkout_params}) do
    case Order.create_checkout(checkout_params) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout created successfully.")
        |> redirect(to: checkout_path(conn, :show, checkout))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    render(conn, "show.html", checkout: checkout)
  end

  def edit(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    changeset = Order.change_checkout(checkout)
    render(conn, "edit.html", checkout: checkout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "checkout" => checkout_params}) do
    checkout = Order.get_checkout!(id)

    case Order.update_checkout(checkout, checkout_params) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout updated successfully.")
        |> redirect(to: checkout_path(conn, :show, checkout))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", checkout: checkout, changeset: changeset)
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
