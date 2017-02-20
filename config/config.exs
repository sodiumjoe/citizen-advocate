# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.
import_config "../apps/*/config/config.exs"

# Sample configuration (overrides the imported configuration above):
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

config :action_data_fetcher, :pools,
  gpo_fetchers: [
    {:name, {:local, :gpo_fetchers}},
    {:worker_module, ActionDataFetcher.GPO.Fetcher.Worker},
    {:size, 5},
    {:max_overflow, 5}
  ],
  gpo_parsers: [
    {:name, {:local, :gpo_parsers}},
    {:worker_module, ActionDataFetcher.GPO.Parser.Worker},
    {:size, 100},
    {:max_overflow, 100}
  ]

config :action_data_fetcher, :timeouts,
  gpo: 90_000

config :action_data_fetcher, :gpo,
    bill_types: ["hr", "s", "hres", "hjres"],
    congress: 115
