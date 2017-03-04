use Mix.Config

config :citizen_advocate_data_fetcher, :gpo,
  http_client: CitizenAdvocateDataFetcher.Test.HTTPClient,
  file_module: CitizenAdvocateDataFetcher.Test.FileModule,
  sys_module: CitizenAdvocateDataFetcher.Test.System,
  date_time: CitizenAdvocateDataFetcher.Test.DateTime

config :citizen_advocate_data_fetcher, :propublica,
  http_client: CitizenAdvocateDataFetcher.Test.HTTPClient
