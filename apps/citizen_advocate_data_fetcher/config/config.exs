# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :citizen_advocate_data_fetcher, key: :value
config :citizen_advocate_data_fetcher, tmp_dir: "/tmp/bill_data"

#
# And access this configuration in your application as:
#
#     Application.get_env(:citizen_advocate_data_fetcher, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#
config :citizen_advocate_data_fetcher, :pools,
  gpo_fetchers: [
    {:name, {:local, :gpo_fetchers}},
    {:worker_module, CitizenAdvocateDataFetcher.GPO.Fetcher.Worker},
    {:size, 5},
    {:max_overflow, 5}
  ],
  gpo_parsers: [
    {:name, {:local, :gpo_parsers}},
    {:worker_module, CitizenAdvocateDataFetcher.GPO.Parser.Worker},
    {:size, 100},
    {:max_overflow, 100}
  ],
  propublica_fetchers: [
    {:name, {:local, :propublica_fetchers}},
    {:worker_module, CitizenAdvocateDataFetcher.Propublica.Worker},
    {:size, 4},
    {:max_overflow, 4}
  ]

config :citizen_advocate_data_fetcher, :timeouts,
  gpo: 90_000,
  propublica: 50_000

config :citizen_advocate_data_fetcher, :congress, 115

config :citizen_advocate_data_fetcher, :gpo,
    bill_types: ["hr", "s", "hres", "hjres"]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env}.exs"
