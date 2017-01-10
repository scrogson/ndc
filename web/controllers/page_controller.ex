defmodule NDC.PageController do
  use NDC.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
