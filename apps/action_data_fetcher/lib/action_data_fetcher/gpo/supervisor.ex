defmodule ActionDataFetcher.GPO.Supervisor do
  use Supervisor

  ## Client API
  
  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_fetcher_pool do
    case Supervisor.start_child(__MODULE__, poolboy_spec()) do
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

  ## Server API

  def init(nil) do
    supervise([], strategy: :one_for_one)
  end

  def handle_call(:fetch_bills, _from, state) do
    IO.puts("FETCH BILLS")
    {:reply, %{}, state}
  end

  defp pool_name do
    :gpo_fetchers
  end

  defp poolboy_spec do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, ActionDataFetcher.GPO.Fetcher.Worker},
      {:size, 5},
      {:max_overflow, 5}
    ]

    :poolboy.child_spec(:worker, poolboy_config, [])
  end

end