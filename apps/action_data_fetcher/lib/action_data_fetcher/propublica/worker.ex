defmodule ActionDataFetcher.Propublica.Worker do
  use GenServer

  @http Application.get_env(:action_data_fetcher, :propublica)[:http_client] || HTTPoison
  @api_key Application.get_env(:action_data_fetch, :propublica)[:api_key] 

  ## Client API

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def fetch_members(pid, congress, chamber) do
    GenServer.call(pid, {:fetch_members, {:congress, congress, :chamber, chamber}})
  end

  def fetch_committees(pid, congress, chamber) do
    GenServer.call(pid, {:fetch_committees, {:congress, congress, :chamber, chamber}})
  end

  ## Server API
  
  def handle_call({:fetch_members, {:congress, congress, :chamber, chamber}}, _from, state) do
    members = generate_members_url(congress, chamber)
      |> fetch_json()
      |> pluck_member_data()

    {:reply, members, state}
  end
  
  def handle_call({:fetch_committees, {:congress, congress, :chamber, chamber}}, _from, state) do
    committees = generate_committess_url(congress, chamber)
      |> fetch_json()
      |> pluck_committee_data()

    {:reply, committees, state}
  end

  ## Internal Helpers

  defp generate_members_url(congress, chamber) do
    "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/members.json"
  end

  defp generate_committess_url(congress, chamber) do
    "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/committees.json"
  end

  defp fetch_json(url) do
    headers = [ "X-API-Key": @api_key ]

    case @http.get(url, headers, ssl: [verify: :verify_none]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
      {:error, reason} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end

  defp pluck_member_data(response_body) do
    case response_body do
      {:error, reason} -> {:error, reason}
      json -> case Poison.Parser.parse(json) do
        {:ok, %{ "results" =>
          # TODO: do we want less than what Propublica provides?
          [%{"members" => members, "num_results" => _result_count}|_]
        }} -> members
        {:error, reason} -> {:error, reason}
      end
    end

  end

  defp pluck_committee_data(response_body) do
    # TODO: do we want less than what Propublica provides?
    {:ok, %{
      "results" => [%{"committees" => committees, "num_results" => _result_count}|_]
      }} = Poison.Parser.parse(response_body)

    committees
  end

end
