defmodule NDC.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user = user_from_session(conn)
    token = user_token(conn, user)

    conn
    |> assign(:current_user, user)
    |> assign(:current_user_token, token)
  end

  defp user_from_session(conn) do
    case get_session(conn, :current_user_id) do
      nil -> nil
      int -> NDC.User.get_user(int)
    end
  end

  defp user_token(conn, %NDC.User{id: id}),
    do: Phoenix.Token.sign(conn, "user socket", id)
  defp user_token(conn, _), do: nil
end
