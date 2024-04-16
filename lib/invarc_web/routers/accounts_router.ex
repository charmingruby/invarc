defmodule InvarcWeb.Routers.AccountsRouter do
  @moduledoc """
  Route groups for "/api/accounts
  """

  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvarcWeb do
    pipe_through :api

    post "/", AccountsController, :register
    get "/me/transactions", AccountsController, :transactions_statement
  end
end
