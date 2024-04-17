defmodule InvarcWeb.Routers.WalletsRouter do
  @moduledoc """
  Routes groups for "/api/wallets
  """

  use InvarcWeb, :router

  alias InvarcWeb.Security.Pipelines

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Pipelines.Protected
  end

  scope "/", InvarcWeb do
    pipe_through [:api, :auth]

    post "/", WalletsController, :create_wallet
    get "/:wallet_id", WalletsController, :get_wallet_by_id
  end
end
