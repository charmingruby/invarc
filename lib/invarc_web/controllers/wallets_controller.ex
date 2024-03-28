defmodule InvarcWeb.WalletsController do
  use InvarcWeb, :controller

  def create_wallet(conn, _) do
    conn
    |> put_status(:created)
    |> json(%{ok: "kkk"})
  end
end
