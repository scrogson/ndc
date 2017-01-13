defmodule NDC.RegistrationController do
  use NDC.Web, :controller
  alias NDC.Registration

  def new(conn, _params) do
    changeset = Registration.new_registration()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"registration" => params}) do
    case Registration.register_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully registered")
        |> put_session(:current_user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
