defmodule InvarcWeb.Routers.AccountsRouter do
  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvarcWeb do
    pipe_through :api

    post "/", AccountsController, :register
  end
end
