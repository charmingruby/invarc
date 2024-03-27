defmodule InvarcWeb.Routers.SessionsRouter do
  @moduledoc """
  Routes groups for "/api/sessions
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
