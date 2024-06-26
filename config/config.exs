# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :invarc,
  ecto_repos: [Invarc.Repo],
  generators: [binary_id: true]

config :invarc, InvarcWeb.Security.Guardian,
  issuer: "invarc",
  secret_key: "OU2cm0zcynVBGikJqLPiOqiidkEH4zF5Os1VGbRMJ4jpuTikL5gc6IoWfxGRNVfw"

config :invarc, InvarcWeb.Security.Pipelines.Protected,
  module: InvarcWeb.Security.Guardian,
  error_handler: InvarcWeb.Security.ErrorHandler

# Configures the endpoint
config :invarc, InvarcWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: InvarcWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Invarc.PubSub,
  live_view: [signing_salt: "oLPIIJGm"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :invarc, Invarc.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
