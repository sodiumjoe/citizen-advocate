defmodule ActionDataFetcher.GPO.Fetcher.Worker do
  use GenServer

  @http Application.get_env(:action, :gpo)[:http_client] || HTTPoison

  def start_link(stuff) do
    GenServer.start_link(__MODULE__, stuff)
  end
  
  def fetch_bills(pid, congress, bill_type) do
    GenServer.call(pid, {:fetch_bills, {:congress, congress, :bill_type, bill_type}})
  end

  def handle_call({:fetch_bills, {:congress, congress, :bill_type, bill_type}}, _from, state) do
    IO.puts("fetch_bills, #{congress}, #{bill_type}")

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

  # TODO: put this in the ParserWorker
  # defp _parse_xml_data(xml) do
  #   xml 
  #    |> xpath(
  #       ~x"//bill",
  #       bill_number: ~x"./billNumber/text()"s,
  #       bill_type: ~x"./billType/text()"s,
  #       title: ~x"./title/text()"s,
  #       update_date: ~x"./updateDate/text()"s,
  #       congress: ~x"./congress/text()"s,
  #       policy_area: ~x"./policyArea/name/text()"s,
  #       actions: [
  #         ~x"./actions/item"l,
  #         action_date: ~x"./actionDate/text()"s,
  #         text: ~x"./text/text()"s,
  #         action_code: ~x"./actionCode/text()"s, # this can be nil
  #         committee: [
  #           ~x"./committee",
  #           system_code: ~x"./systemCode/text()"s,
  #           name: ~x"./name/text()"s
  #         ]
  #       ],
  #       subjects: [
  #         # TODO:
  #         # https://github.com/usgpo/bill-status/blob/master/BILLSTATUS-XML_User_User-Guide.md
  #         # seems to imply there are other types of subjects, but need to find example
  #         # otherwise we can collapse this a bit
  #         ~x"./subjects/billSubjects",
  #         legislative_subjects: [
  #           ~x"./legislativeSubjects/item"l,
  #           name: ~x"./name/text()"s
  #         ]
  #       ]
  #       # TODO: should we also capture relatedBill, summaries, or titles?
  #     )
  # end
end
