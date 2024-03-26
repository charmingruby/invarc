defmodule InvarcWeb.AccountsController do
  alias InvarcWeb.Helpers
  use InvarcWeb, :controller

  @register_params_schema %{
    name: [:string, required: true],
    email: [:string, required: true],
    password: [:string, required: true]
  }
  def register(conn, params) do
    with {:ok, casted_params} <- Helpers.Params.cast_params(params, @register_params_schema) do
      conn
      |> put_status(:created)
      |> render(:account, account: casted_params)
    end
  end
end
