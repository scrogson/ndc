defmodule NDC.RoomChannel do
  use NDC.Web, :channel
  alias NDC.{Message, Presence, Room}

  def join("rooms:" <> name, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    user = socket.assigns.user
    room = socket.assigns.room

    {:ok, msg} = NDC.Message.insert_message(room, user, body)
    msg = to_map(msg)

    broadcast socket, "new_msg", msg

    {:reply, {:ok, msg}, socket}
  end

  defp to_map(msg) do
    %{id: msg.id,
      from: msg.user.name,
      avatar: avatar(msg.user.email),
      body: msg.body}
  end

  defp user_meta(user),
    do: %{name: user.name, avatar: avatar(user.email)}

  defp avatar(email) do
    Exgravatar.gravatar_url(email, s: 64)
  end
end
