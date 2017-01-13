defmodule NDC.Router do
  use NDC.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NDC.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NDC do
    pipe_through :browser # Use the default browser stack

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    delete "/signout", SessionController, :delete

    resources "/rooms", RoomController, except: [:edit, :update, :delete]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", NDC do
  #   pipe_through :api
  # end
end
