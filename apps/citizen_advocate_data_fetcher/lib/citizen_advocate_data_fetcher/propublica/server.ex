defmodule CitizenAdvocateDataFetcher.Propublica.Server do
  use GenServer

  @timeout Application.get_env(:citizen_advocate_data_fetcher, :timeouts)[:propublica]
  @congress Application.get_env(:citizen_advocate_data_fetcher, :congress)
  @chambers ["house", "senate"]

  ## Client API
  
  def fetch_committee_data do
    GenServer.call(__MODULE__, {:fetch_committee_data}, @timeout)
  end
  
  def fetch_member_data do
    GenServer.call(__MODULE__, {:fetch_member_data}, @timeout)
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
  end

  ## Server API

  def init(nil) do
    # TODO: currently, if the pools die, they are never restarted..
    send(self(), {:start_fetcher_pool})

    {:ok, %{}}
  end

  def handle_call({:fetch_committee_data}, _from, state) do
    tasks = Enum.map(@chambers, &queue_fetch(&1, :fetch_committees))

    results = tasks
      |> Enum.map(fn(task) -> Task.await(task, @timeout) end)
      |> Enum.map(fn(response) -> response end)

    {:reply, results, state}
  end

  def handle_call({:fetch_member_data}, _from, state) do
    tasks = Enum.map(@chambers, &queue_fetch(&1, :fetch_members))

    results = tasks
      |> Enum.map(fn(task) -> Task.await(task, @timeout) end)
      |> Enum.map(fn(response) -> response end)

    {:reply, results, state}
  end

  def handle_info({:start_fetcher_pool}, state) do
    CitizenAdvocateDataFetcher.Propublica.Supervisor.start_fetcher_pool
    {:noreply, state}
  end

  ## Internal Helpers

  defp queue_fetch(chamber, fetch_msg) do
    Task.async(
      fn -> :poolboy.transaction(:propublica_fetchers,
        &(GenServer.call(&1, {fetch_msg, { :congress, @congress, :chamber, chamber}}, @timeout)
      ), @timeout)
    end)
  end

end
