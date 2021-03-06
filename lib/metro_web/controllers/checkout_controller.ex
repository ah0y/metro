defmodule MetroWeb.CheckoutController do
  use MetroWeb, :controller

  alias Metro.Order
  alias Metro.Order.Checkout
  alias Metro.Account
  alias Metro.Location
  alias Metro.Repo

  import Ecto.Query

  plug :authorize_resource, model: Checkout
  use MetroWeb.ControllerAuthorization

  def index(
        conn,
        %{
          "page" => pagenumber,
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    query_params = from c in Checkout, where: field(c, ^search_by) == ^query and not(is_nil(c.copy_id))

    try do
      page = Metro.Repo.paginate(query_params, page: pagenumber)
      render conn, "index.html", checkouts: page.entries, page: page
    rescue _ ->
      redirect(conn, to: Routes.checkout_path(conn, :index))
    end
  end

  def index(
        conn,
        %{
          "_utf8" => status,
          "search" => %{
            "query" => query,
            "search_by" => search_by
          }
        } = params
      ) do

    search_by =
      search_by
      |> String.to_atom()

    query_params = from c in Checkout, where: field(c, ^search_by) == ^query and not(is_nil(c.copy_id))

    try do
      page = Metro.Repo.paginate(query_params, page: 1)
      render conn, "index.html", checkouts: page.entries, page: page
    rescue _ ->
      redirect(conn, to: Routes.checkout_path(conn, :index))
    end
  end

  def index(conn, params = %{}) do
    query_params  = from c in Checkout, where: not(is_nil(c.copy_id))
    pagenumber = conn.params["page"] || 1
    page = Repo.paginate(query_params, page: pagenumber)
    render conn, "index.html", checkouts: page.entries, page: page
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
    user =
      Metro.Account.get_user!(conn.assigns.current_user.id)
      |> Repo.preload([{:card, :checkouts}])
    copy = Location.find_copy(Map.get(checkout_params, "isbn_id"))
    case Order.create_order(user, checkout_params, copy) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Checkout created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, conn.assigns.current_user.id))
      {:error, :checkout, %Ecto.Changeset{} = changeset, %{}} ->
        libraries = Location.load_libraries()
        render(
          conn,
          "new.html",
          changeset: changeset,
          isbn: Map.get(changeset.changes, :isbn_id),
          libraries: libraries
        )
      {:error, :checkout, "user has an overdue book", %{}} ->
        conn
        |> put_flash(:error, "user has an overdue book.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, :checkout, "user has unpaid library fines", %{}} ->
        conn
        |> put_flash(:error, "user has unpaid library fines.")
        |> redirect(to: Routes.user_path(conn, :show, user))
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
        |> redirect(to: Routes.checkout_path(conn, :show, checkout))
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

    case Order.check_in(checkout.copy) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout updated successfully.")
        |> redirect(to: Routes.checkout_path(conn, :index))
      {:error, _} ->
        IO.puts("error")
    end
  end

  def process(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    case Order.process_checkout(checkout) do
      {:ok, checkout} ->
        conn
        |> put_flash(:info, "Checkout processed successfully.")
        |> redirect(to: Routes.checkout_path(conn, :index))
      {:error, _} ->
        IO.puts("error")
    end
  end

  def delete(conn, %{"id" => id}) do
    checkout = Order.get_checkout!(id)
    {:ok, _checkout} = Order.delete_checkout(checkout)

    conn
    |> put_flash(:info, "Checkout deleted successfully.")
    |> redirect(to: Routes.checkout_path(conn, :index))
  end
end
