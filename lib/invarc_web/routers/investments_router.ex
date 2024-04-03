defmodule InvarcWeb.Routers.InvestmentsRouter do
  @moduledoc """
  Routes groups for "/api/investments
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

    post "/categories", InvestmentsController, :create_investment_category
    post "/", InvestmentsController, :create_investment
  end
end
