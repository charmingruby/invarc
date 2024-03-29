defmodule InvarcWeb.Helpers.Connection do
  @moduledoc """
  Helper function to handle with connection
  """

  alias InvarcWeb.Security.Guardian

  import Plug.Conn

  def retrieve_token_payload(conn) do
    ["Bearer " <> token] = get_req_header(conn, "authorization")

    Guardian.resource_from_token(token)
  end
end
