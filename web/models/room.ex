defmodule NDC.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias NDC.{Message, Repo, Room}

  schema "rooms" do
    field :name, :string
    field :description, :string

    has_many :messages, Message
  end

  def new do
    cast(%Room{}, %{}, ~w(name description)a)
  end

  def insert_room(params) do
    fields = ~w(name description)a

    %Room{}
    |> cast(params, fields)
    |> validate_required([:name])
    |> update_change(:name, &String.downcase/1)
    |> Repo.insert()
  end

  def list_rooms do
    Repo.all(Room)
  end

  def get_room(name) do
    Repo.get_by(Room, name: name)
  end

  def get_room(name) do
    Repo.get_by(Room, name: name)
  end

  def with_messages(%Room{} = room) do
    Repo.preload(room, [messages: :user])
  end
end
