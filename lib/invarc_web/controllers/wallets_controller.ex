defmodule InvarcWeb.WalletsController do
  use InvarcWeb, :controller

  alias InvarcWeb.Helpers

  action_fallback InvarcWeb.FallbackController

  @create_wallet_params_schema %{
    name: [:string, required: true]
  }
  def create_wallet(conn, params) do
    with {:ok, casted_params} <- Helpers.Params.cast_params(params, @create_wallet_params_schema),
         {:ok, account, _claims} <- Helpers.Connection.retrieve_token_payload(conn),
         built_params <- Map.put(casted_params, :account_id, account.id),
         {:ok, wallet} <- Invarc.Investments.create_wallet(built_params) do
      conn
      |> put_status(:created)
      |> render(:wallet, wallet: wallet)
    end
  end
end
