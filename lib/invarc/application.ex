defmodule Invarc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InvarcWeb.Telemetry,
      # Start the Ecto repository
      Invarc.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Invarc.PubSub},
      # Start Finch
      {Finch, name: Invarc.Finch},
      # Start the Endpoint (http/https)
      InvarcWeb.Endpoint
      # Start a worker by calling: Invarc.Worker.start_link(arg)
      # {Invarc.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Invarc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvarcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
