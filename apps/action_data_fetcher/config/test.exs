use Mix.Config

config :action_data_fetcher, :gpo,
  http_client: ActionDataFetcher.Test.HTTPClient
