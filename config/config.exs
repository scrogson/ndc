# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ndc,
  namespace: NDC,
  ecto_repos: [NDC.Repo]

# Configures the endpoint
config :ndc, NDC.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dlJE1bJtasYG1kp4MDO3cVfOemZ+jxOT85M3usSSdG/ZT59+8KjFLQbT9BIijt4I",
  render_errors: [view: NDC.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NDC.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
