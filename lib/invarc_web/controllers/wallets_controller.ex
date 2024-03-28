defmodule InvarcWeb.WalletsController do
  use InvarcWeb, :controller

  alias InvarcWeb.Helpers

  @create_wallet_params_schema %{
    name: [:string, required: true]
  }
  def create_wallet(conn, _) do
    Helpers.Connection.retrieve_token_payload(conn) |> IO.inspect()

    conn
    |> put_status(:created)
    |> json(%{ok: true})
  end
end
