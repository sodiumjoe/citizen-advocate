defmodule CitizenAdvocate.Router do
  use CitizenAdvocate.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CitizenAdvocate.Auth, repo: CitizenAdvocate.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CitizenAdvocate do
    pipe_through :browser
    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/register", UserController, :new
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CitizenAdvocate do
  #   pipe_through :api
  # end
end
