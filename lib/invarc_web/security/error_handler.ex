defmodule InvarcWeb.Security.ErrorHandler do
  alias Guardian.Plug.ErrorHandler
  alias Plug.Conn
  @behaviour ErrorHandler

  def auth_error(conn, {error, _reasons}, _opts) do
    body = Jason.encode!(%{message: to_string(error)})

    Conn.send_resp(conn, 401, body)
  end
end
