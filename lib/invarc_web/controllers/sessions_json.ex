defmodule InvarcWeb.SessionsJSON do
  def session(%{token: token}) do
    build_session(token)
  end

  defp build_session(session) do
    %{
      access_token: session
    }
  end
end
