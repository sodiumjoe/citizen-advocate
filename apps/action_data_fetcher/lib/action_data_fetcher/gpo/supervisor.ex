defmodule ActionDataFetcher.GPO.Supervisor do
  use Supervisor

  ## Client API
  
  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_fetcher_pool do
    start_pool(poolboy_fetcher_spec())
  end

  def start_parser_pool do
    start_pool(poolboy_parser_spec())
  end

  ## Server API

  def init(nil) do
    supervise([], strategy: :one_for_one)
  end

  defp poolboy_fetcher_spec do
    poolboy_config = Application.get_env(:action_data_fetcher, :pools)[:gpo_fetchers]

    :poolboy.child_spec(:gpo_fetchers, poolboy_config, [])
  end

  defp poolboy_parser_spec do
    poolboy_config = Application.get_env(:action_data_fetcher, :pools)[:gpo_parsers]

    :poolboy.child_spec(:gpo_parsers, poolboy_config, [])
  end

  defp start_pool(poolboy_spec) do
    case Supervisor.start_child(__MODULE__, poolboy_spec) do
      {:pool_started, pool_pid} ->
        {:ok, pool_pid}
      {:ok, pool_pid} ->
        {:ok, pool_pid}
      {:error, {:already_started, _}} ->
        {:ok, :already_started}
      other ->
        IO.puts("TODO: HANDLE UNEXPECTED ERROR... #{inspect other}")
        {:error, :nostart}
    end
  end
end
