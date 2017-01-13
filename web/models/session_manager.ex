defmodule NDC.SessionManager do
  alias NDC.{User, Repo}

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def create_session(email, password) do
    user = Repo.get_by(User, email: email)
    if user && checkpw(password, user.hashed_password) do
      {:ok, user}
    else
      dummy_checkpw()
      :error
    end
  end
end
