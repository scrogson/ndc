defmodule NDC.User do
  use Ecto.Schema
  schema "users" do
    field :name, :string
    field :email, :string
    field :hashed_password, :string

    timestamps()
  end

  def get_user(id) do
    NDC.Repo.get(NDC.User, id)
  end
end
