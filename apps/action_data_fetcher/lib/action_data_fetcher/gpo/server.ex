defmodule ActionDataFetcher.GPO.Server do
  use GenServer

  defmodule State do
    defstruct fetchers: nil, max_fetchers: nil, waiting: nil
  end

  ## Client API
  
  def fetch_gpo_bill_data do
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
  end

  ## Server API

  def init(nil) do
    # poolboy_config = [
    #   {:name, {:local, pool_name()}},
    #   {:worker_module, Action.DataFetch.GPO.Fetcher.Worker},
    #   {:size, 5},
    #   {:max_overflow, 5}
    # ]

    state = %State{fetchers: [], max_fetchers: 5, waiting: []}

    send(self(), {:start_fetcher_pool})#, {:pool_name, pool_name(), pool_config: poolboy_config}})

    {:ok, state}
  end

  def handle_call({:fetch_bills_data}, _from, state) do
    IO.puts("FETCH ME SOME DATA!!!!")
    {:reply, %{}, state}
  end

  # def handle_info({:start_fetcher_pool, {:pool_name, pool_name, :poolboy_config, poolboy_config}}) do
  def handle_info({:start_fetcher_pool}, state) do
    ActionDataFetcher.GPO.Supervisor.start_fetcher_pool
    {:noreply, state}
  end

  ## Helpers

  # defp pool_name do
  #   :gpo_fetchers
  # end
end
