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

  @get_wallet_by_id_params_schema %{
    wallet_id: [type: Ecto.UUID, required: true]
  }
  def get_wallet_by_id(conn, params) do
    with {:ok, casted_params} <-
           Helpers.Params.cast_params(params, @get_wallet_by_id_params_schema),
         {:ok, account, _claims} <- Helpers.Connection.retrieve_token_payload(conn),
         built_params <- Map.put(casted_params, :account, account),
         {:ok, wallet} <- Invarc.Investments.get_wallet_by_id(built_params) do
      conn
      |> put_status(:ok)
      |> render(:wallet, wallet: wallet)
    end
  end

  @fetch_account_wallets_params_schema %{
    page: [type: :integer, default: 1]
  }
  def fetch_account_wallets(conn, params) do
    with {:ok, casted_params} <-
           Helpers.Params.cast_params(params, @fetch_account_wallets_params_schema),
         {:ok, account, _claims} <- Helpers.Connection.retrieve_token_payload(conn),
         built_params = Map.put(casted_params, :account_id, account.id),
         {:ok, wallets} <- Invarc.Investments.fetch_account_wallets(built_params) do
      conn
      |> put_status(:ok)
      |> render(:wallet_list, wallets: wallets)
    end
  end
end
