defmodule InvarcWeb.Routers.AccountsRouter do
  @moduledoc """
  Routes groups for "/api/accounts
  """

  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvarcWeb do
    pipe_through :api

    post "/", AccountsController, :register
  end
end
