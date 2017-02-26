defmodule ActionDataFetch.Propublica.Worker do
  use GenServer

  @api_key Application.get_env(:action_data_fetch, :propublica)[:api_key]

  ## Client API

  def start_link(stuff) do
    GenServer.start_link(__MODULE__, stuff)
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

    {:ok, response} = HTTPoison.get(url, headers, ssl: [verify: :verify_none])

    response.body
  end

  defp pluck_member_data(response_body) do
    {:ok, %{
      "results" => [%{"members" => members, "num_results" => _result_count}|_]
      }} = Poison.Parser.parse(response_body)

    members
  end

  defp pluck_committee_data(response_body) do
    {:ok, %{
      "results" => [%{"committees" => committees, "num_results" => _result_count}|_]
      }} = Poison.Parser.parse(response_body)

    committees
  end

end  
