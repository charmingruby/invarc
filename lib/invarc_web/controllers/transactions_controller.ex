defmodule InvarcWeb.TransactionsController do
  use InvarcWeb, :controller

  alias InvarcWeb.Helpers

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
