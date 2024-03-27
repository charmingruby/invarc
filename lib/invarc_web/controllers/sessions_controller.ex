defmodule InvarcWeb.SessionsController do
  use InvarcWeb, :controller

  alias Invarc.Accounts.UseCases
  alias InvarcWeb.{FallbackController, Helpers, Security}

  action_fallback FallbackController

  @authenticate_params_schema %{
    email: [:string, required: true],
    password: [:string, required: true]
  }
  def authenticate(conn, params) do
    with {:ok, casted_params} <- Helpers.Params.cast_params(params, @authenticate_params_schema),
         {:ok, account} <- UseCases.Authenticate.call(casted_params),
         {:ok, token, _} <- Security.Guardian.generate_token(account) do
      conn
      |> put_status(:ok)
      |> render(:session, token: token)
    end
  end
end
