# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :action,
  ecto_repos: [Action.Repo]

# Configures the endpoint
config :action, Action.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G6wtBOC4U5so7AKp3J6L2oktZ/40L3veoWQoIq8JpMY0au+b0VO277FtgDBECKpk",
  render_errors: [view: Action.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Action.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
