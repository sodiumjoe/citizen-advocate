defmodule ActionDataFetcher.GPO.Fetcher.Worker do
  use GenServer

  def start_link(stuff) do
    GenServer.start_link(__MODULE__, stuff)
  end
  
  def fetch_bills(pid, congress, bill_type) do
    GenServer.call(pid, {:fetch_bills, {:congress, congress, :bill_type, bill_type}})
  end

  def handle_call({:fetch_bills, {:congress, congress, :bill_type, bill_type}}, _from, state) do
    IO.puts("fetch_bills, #{congress}, #{bill_type}")
    :timer.sleep(1000)
    {:reply, :TBD, state}
  end
end
