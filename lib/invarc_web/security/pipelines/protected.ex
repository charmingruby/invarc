defmodule InvarcWeb.Security.Pipelines.Protected do
  use Guardian.Plug.Pipeline, otp_app: :invarc

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
