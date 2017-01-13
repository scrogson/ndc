defmodule NDC.SessionController do
  use NDC.Web, :controller
  alias NDC.SessionManager

  def new(conn, _params) do
    if get_session(conn, :current_user_id) do
      conn
      |> put_flash(:info, "You're already signed in")
      |> redirect(to: page_path(conn, :index))
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case SessionManager.create_session(email, pass) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully signed in.")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: page_path(conn, :index))
      :error ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end
