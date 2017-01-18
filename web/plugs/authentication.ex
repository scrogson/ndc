defmodule NDC.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user = user_from_session(conn)

    conn
    |> assign(:current_user, user)
  end

  defp user_from_session(conn) do
    case get_session(conn, :current_user_id) do
      nil -> nil
      int -> NDC.User.get_user(int)
    end
  end
end
