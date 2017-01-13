defmodule NDC.RoomController do
  use NDC.Web, :controller

  alias NDC.Room

  def index(conn, _) do
    rooms = Room.list_rooms()
    render conn, "index.html", rooms: rooms
  end

  def show(conn, %{"id" => id}) do
    if room = Room.get_room(id) do
      render conn, "show.html", room: room
    else
      conn
      |> put_flash(:error, "No room found")
      |> redirect(to: room_path(conn, :index))
    end
  end

  def new(conn, _) do
    changeset = Room.new()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"room" => params}) do
    case Room.insert_room(params) do
      {:ok, room} ->
        redirect conn, to: room_path(conn, :show, room.name)
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
