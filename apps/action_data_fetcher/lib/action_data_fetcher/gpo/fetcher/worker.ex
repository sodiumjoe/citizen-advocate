defmodule ActionDataFetcher.GPO.Fetcher.Worker do
  use GenServer

  @http Application.get_env(:action_data_fetcher, :gpo)[:http_client] || HTTPoison

  def start_link(stuff) do
    GenServer.start_link(__MODULE__, stuff)
  end
  
  def fetch_bills(pid, congress, bill_type) do
    GenServer.call(pid, {:fetch_bills, {:congress, congress, :bill_type, bill_type}})
  end

  def handle_call({:fetch_bills, {:congress, congress, :bill_type, bill_type}}, _from, state) do
	response = case fetch_zip(congress, bill_type) do
      {:ok, %HTTPoison.Response{status_code: 200, body: zip}} ->
        {:ok, {:data, zip, :congress, congress, :bill_type, bill_type}}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
        _ -> {:error, :unknown}
    end

    {:reply, response, state}
  end

  defp fetch_zip(congress, type) do
    generate_url(congress, type) 
    |> @http.get([timeout: 90_000]) # TODO: Magic constant
  end

  defp generate_url(congress, bill_type) do
    "https://www.gpo.gov/fdsys/bulkdata/BILLSTATUS/#{congress}/#{bill_type}/BILLSTATUS-#{congress}-#{bill_type}.zip"
  end

end
