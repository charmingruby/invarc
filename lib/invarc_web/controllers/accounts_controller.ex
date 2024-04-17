defmodule InvarcWeb.AccountsController do
  use InvarcWeb, :controller

  alias Invarc.Accounts
  alias InvarcWeb.Helpers

  action_fallback InvarcWeb.FallbackController

  @register_params_schema %{
    name: [:string, required: true],
    email: [:string, required: true],
    password: [:string, required: true]
  }
  def register(conn, params) do
    with {:ok, casted_params} <- Helpers.Params.cast_params(params, @register_params_schema),
         {:ok, account} <- Accounts.register(casted_params) do
      conn
      |> put_status(:created)
      |> render(:account, account: account)
    end
  end
end
