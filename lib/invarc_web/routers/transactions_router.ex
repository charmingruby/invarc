defmodule InvarcWeb.Routers.TransactionsRouter do
  @moduledoc """
  Route groups for "/api/transactions
  """

  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvarcWeb do
    pipe_through :api

    get "/statement", TransactionsController, :transactions_statement
  end
end
