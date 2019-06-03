defmodule MetroWeb.UserController do
  use MetroWeb, :controller

  alias Metro.Account
  alias Metro.Account.User

  import Ecto.Query

  plug :load_and_authorize_resource, model: Metro.Account.User, preload: :card
  use MetroWeb.ControllerAuthorization

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Account.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user =
      Account.get_user!(id)
      |> Metro.Repo.preload(:checkouts)

    checkouts = Enum.reduce(
      user.checkouts,
      %{:checked_in => [], :checked_out => [], :waitlist => [], :transit => [], :pickup => []},
      fn c, checkouts ->
        cond do
          c.checkin_date != nil -> Map.update(checkouts, :checked_in, c, &[c | &1])

          c.checkout_date != nil -> Map.update(checkouts, :checked_out, c, &[c | &1])

          c.copy_id == nil ->
            c = Metro.Repo.preload(c, :waitlists)
            Map.update(checkouts, :waitlist, c, &[c | &1])
          true ->
            c = Metro.Repo.preload(c, [:transit])
            if c.transit.actual_arrival != nil do
              c = Metro.Repo.preload(c,  :reservation)
              Map.update(checkouts, :pickup, c, &[c | &1])
            else
              Map.update(checkouts, :transit, c, &[c | &1])
            end
        end
      end
    )

    render(
      conn,
      "show.html",
      user: user,
      checkouts: checkouts
    )
  end

  def edit(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    changeset = Account.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)
    case Account.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    {:ok, _user} = Account.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
