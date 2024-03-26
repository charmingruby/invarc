defmodule InvarcWeb.FallbackController do
  use InvarcWeb, :controller

  def call(conn, %Ecto.Changeset{} = changeset) do
    conn
    |> put_status(422)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, reason: reason)
  end
end
