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

  @transactions_statement_params_schema %{
    page: [type: :integer, default: 0]
  }
  def transactions_statement(conn, params) do
    with {:ok, casted_params} <-
           Helpers.Params.cast_params(params, @transactions_statement_params_schema),
         {:ok, account, _claims} <- Helpers.Connection.retrieve_token_payload(conn),
         built_params = Map.put(casted_params, :account_id, account.id),
         {:ok, transactions} <- Invarc.Investments.transactions_statement(built_params) do
      conn
      |> put_status(:ok)
      |> render(:transaction_list, transactions: transactions)
    end
  end
end
