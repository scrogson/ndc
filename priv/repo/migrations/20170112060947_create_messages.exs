defmodule NDC.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :description, :string
    end

    create table(:messages) do
      add :user_id, references(:users)
      add :room_id, references(:rooms)
      add :body, :string

      timestamps()
    end
  end
end
