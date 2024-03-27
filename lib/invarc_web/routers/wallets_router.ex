defmodule InvarcWeb.Routers.WalletsRouter do
  @moduledoc """
  Routes groups for "/api/wallets
  """

  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvarcWeb do
    pipe_through :api

    post "/", SessionsController, :authenticate
  end
end
