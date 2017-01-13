defmodule NDC.Message do
  use Ecto.Schema

  alias NDC.{Message, Repo, Room, User}

  schema "messages" do
    belongs_to :user, User
    belongs_to :room, Room
    field :body, :string

    timestamps()
  end

  def insert_message(room, user, body) do
    {:ok, msg} = Repo.insert(%Message{
      user_id: user.id,
      room_id: room.id,
      body: body
    })

    {:ok, msg
          |> Map.put(:user, user)
          |> Map.put(:room, room)}
  end
end
