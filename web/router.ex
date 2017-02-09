defmodule Action.Router do
  use Action.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Action.Auth, repo: Action.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Action do
    pipe_through :browser
    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/register", UserController, :new
    resources "/users", UserController, only: [:index, :show]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Action do
  #   pipe_through :api
  # end
end
