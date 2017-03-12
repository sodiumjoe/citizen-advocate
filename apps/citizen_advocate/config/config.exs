# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :citizen_advocate,
  ecto_repos: [CitizenAdvocate.Repo]

# Configures the endpoint
config :citizen_advocate, CitizenAdvocate.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G6wtBOC4U5so7AKp3J6L2oktZ/40L3veoWQoIq8JpMY0au+b0VO277FtgDBECKpk",
  render_errors: [view: CitizenAdvocate.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CitizenAdvocate.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# additional keys `api_key` and `domain` are in .secret.exs
config :citizen_advocate, CitizenAdvocate.Mailer,
  adapter: Bamboo.MailgunAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "#{Mix.env}.secret.exs"
