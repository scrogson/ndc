defmodule NDC.RoomChannel do
  use NDC.Web, :channel
  alias NDC.Presence

  def join("rooms:" <> room_name, payload, socket) do
    room = NDC.Room.get_room(room_name)
    user = socket.assigns.user

    if authorized?(room, user) do
      send(self(), :after_join)
      {:ok, assign(socket, :room, room)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    user = socket.assigns.user
    room = socket.assigns.room
    {:ok, msg} = NDC.Message.insert_message(room, user, body)

    broadcast socket, "new_msg", to_map(msg)

    {:reply, {:ok, to_map(msg)}, socket}
  end

  def handle_info(:after_join, socket) do
    user = socket.assigns.user
    room = socket.assigns.room

    messages = NDC.Room.with_messages(room).messages
    messages = Enum.map(messages, &to_map/1)

    push socket, "msg_history", %{messages: messages}
    push socket, "presence_state", Presence.list(socket)

    Presence.track(socket, user.id, user_meta(user))

    {:noreply, socket}
  end

  defp user_meta(user) do
    %{name: user.name, avatar: gravatar(user)}
  end

  defp to_map(msg) do
    %{id: msg.id,
      from: msg.user.name,
      avatar: gravatar(msg.user),
      body: msg.body}
  end

  # Add authorization logic here as required.
  defp authorized?(_room, _user) do
    true
  end

  defp gravatar(user) do
    Exgravatar.gravatar_url(user.email, s: 64)
  end
end
