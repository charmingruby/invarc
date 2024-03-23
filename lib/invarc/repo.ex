defmodule Invarc.Repo do
  use Ecto.Repo,
    otp_app: :invarc,
    adapter: Ecto.Adapters.Postgres
end
