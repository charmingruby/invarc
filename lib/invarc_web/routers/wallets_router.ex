defmodule InvarcWeb.Routers.WalletsRouter do
  @moduledoc """
  Routes groups for "/api/wallets
  """
  alias InvarcWeb.Security.Pipelines

  use InvarcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Pipelines.Protected
  end

  scope "/", InvarcWeb do
    pipe_through [:api, :auth]

    post "/", WalletsController, :create_wallet
  end
end
