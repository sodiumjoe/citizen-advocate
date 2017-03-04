defmodule CitizenAdvocateDataFetcher.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(CitizenAdvocateDataFetcher.GPO.Supervisor, []),
      worker(CitizenAdvocateDataFetcher.GPO.Server, []),
      supervisor(CitizenAdvocateDataFetcher.Propublica.Supervisor, []),
      worker(CitizenAdvocateDataFetcher.Propublica.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CitizenAdvocateDataFetcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
