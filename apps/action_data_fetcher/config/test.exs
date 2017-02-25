use Mix.Config

config :action_data_fetcher, :gpo,
  http_client: ActionDataFetcher.Test.HTTPClient,
  file_module: ActionDataFetcher.Test.FileModule,
  sys_module: ActionDataFetcher.Test.System,
  date_time: ActionDataFetcher.Test.DateTime
