defmodule MetroWeb.Plug.LogAuthenticatedUser do

  @moduledoc """
  Plug to log authenticated user's id.

  ## Examples

      defmodule MetroWeb.Router do

        pipeline :protected do
          # ...
         plug Coherence.Authentication.Session, protected: true

         plug MetroWeb.Plug.LogAuthentictedUser
         # or override the field name
         plug MetroWeb.Plug.LogAuthentictedUser, header_field_name: "user_id"
         # or disable it with
         plug MetroWeb.Plug.LogAuthentictedUser, header_field_name: false
         # or set :current_user_id_field in The projects config
         plug MetroWeb.Plug.LogAuthentictedUser

  """
  require Logger

  alias Plug.Conn

  @behaviour Plug

  # this needs to be bound at compile time, otherwise it will fail in a
  # production release where mix is not available.
  @app Mix.Project.config[:app]


  def init(opts) do
    # set the header field name. Use the value provided in opts when the plug is
    # called, otherwise try the :current_user_id_field value from the project config,
    # otherwise use "current_user_id"
    env = Application.get_env(@app, :current_user_field, "current_user_id")


    %{
      header_field_name: Keyword.get(
        opts,
        :header_field_name,
        env
      )
    }

  end

  def call(conn, opts) do
    conn
    |> get_user_id
    |> set_user_id(opts)
  end

  defp get_user_id(conn) do
    # note that the following will throw an exception if :current_user is not assigned
    # %{ current_user: current_user } = conn.assigns
    # so its safer to do a case on conn.assigns and match on %{current_user: current_user}
    # even better, use the current_user/1 helper that take into account changing the
    # current_user assigns key.
    case Coherence.current_user(conn) do
      nil -> {conn, nil}
      current_user ->
        # simple to_string here will handle the case where id is integer, binary, or nil
        {conn, to_string(current_user.id)}
    end
  end

  # probably not needed, but just in case its set to an empty string
  defp set_user_id({conn, _user_id}, %{header_field_name: ""}) do
    conn
  end

  # don't try to set the user_id if its nil. Note that to_string of nil is ""
  defp set_user_id({conn, nil_or_empty, _opts}) when nil_or_empty in [nil, ""] do
    conn
  end

  # valid user_id and header_field_name
  defp set_user_id({conn, user_id}, %{header_field_name: field_name}) when is_binary(field_name) do
    Logger.metadata(user_id: user_id)
    conn =
      conn
      |> Plug.Conn.assign(:user_id, user_id)
  end

  # catch all
  defp set_user_id({conn, _}, _) do
    conn
  end
end