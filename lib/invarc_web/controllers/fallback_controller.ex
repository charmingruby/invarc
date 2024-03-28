defmodule InvarcWeb.FallbackController do
  use InvarcWeb, :controller
  # -
  # Changeset errors
  # -
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    err = %{status: :unprocessable_entity, changeset: changeset}

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, error: err)
  end

  # -
  # Not Found
  # -
  def call(conn, {:error, {:not_found, entity}}) do
    err = %{status: :not_found, entity: entity}

    conn
    |> put_status(:not_found)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, error: err)
  end

  # -
  # Authentication errors
  # -
  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, status: :invalid_credentials)
  end

  # -
  # Bad request errors
  # -
  def call(conn, {:error, {:params_cast, params}}) do
    err = %{status: :bad_request, params: params}

    conn
    |> put_status(:bad_request)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, error: err)
  end

  # -
  # Not handled error
  # -
  def call(conn, {:error, reason}) do
    conn
    |> put_status(500)
    |> put_view(json: InvarcWeb.ErrorJSON)
    |> render(:error, reason: reason)
  end
end
