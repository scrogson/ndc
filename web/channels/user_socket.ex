defmodule NDC.UserSocket do
  use Phoenix.Socket

  ## Channels
  #channel "rooms:*", NDC.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user_id} ->
        user = NDC.User.get_user(user_id)
        {:ok, assign(socket, :user, user)}
      {:error, _reason} ->
        :error
    end
  end
  def connect(_, _), do: :error

  def id(_socket), do: nil
end
