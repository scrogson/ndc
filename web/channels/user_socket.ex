defmodule NDC.UserSocket do
  use Phoenix.Socket

  channel "rooms:*", NDC.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token) do
      {:ok, user_id} ->
        user = NDC.User.get_user(user_id)
        {:ok, assign(socket, :user, user)}
      {:error, _error} ->
        :error
    end
  end

  def id(socket), do: "user_socket:#{socket.assigns.user.id}"
end
