defmodule NDC.Registration do
  use Ecto.Schema
  alias NDC.Repo
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  embedded_schema do
    field :name, :string
    field :email, :string
    field :password, :string
    field :password_confirmation, :string
  end

  defp fields, do: ~w(name email password password_confirmation)a

  def new_registration do
    cast(%NDC.Registration{}, %{}, fields())
  end

  def register_user(params) do
    params
    |> insert_changeset()
    |> to_user_changeset()
    |> Repo.insert()
  end

  defp insert_changeset(params) do
    %NDC.Registration{}
    |> cast(params, fields())
    |> validate_required(fields())
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password, message: "must match password")
    |> hash_password()
  end

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset), do:
    put_change(changeset, :hashed_password, hashpwsalt(pass))
  defp hash_password(changeset), do: changeset

  defp to_user_changeset(%{valid?: true, changes: changes}) do
    user_fields = ~w(name email hashed_password)a

    %NDC.User{}
    |> cast(Map.take(changes, user_fields), user_fields)
    |> unique_constraint(:email)
  end
  defp to_user_changeset(changeset), do: changeset
end
