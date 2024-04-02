defmodule InvarcWeb.InvestmentsController do
  use InvarcWeb, :controller

  alias InvarcWeb.Helpers

  action_fallback InvarcWeb.FallbackController

  @create_investment_category_params_schema %{
    name: [:string, required: true]
  }
  def create_investment_category(conn, params) do
    with {:ok, casted_params} <-
           Helpers.Params.cast_params(params, @create_investment_category_params_schema),
         {:ok, account, _claims} <- Helpers.Connection.retrieve_token_payload(conn),
         built_params = Map.put(casted_params, :account_id, account.id),
         {:ok, category} <- Invarc.Investments.create_category(built_params) do
      conn
      |> put_status(:created)
      |> render(:category, category: category)
    end
  end
end
