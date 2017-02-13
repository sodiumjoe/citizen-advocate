defmodule Action.DataFetch.GPO.Worker do
  import SweetXml

  @http Application.get_env(:action, :gpo)[:http_client] || HTTPoison
  
  @doc """
  Start worker to fetch bill data for given `congress`, `type`, and `bill_number`

  Sends message to `owner` on completion:
    {:ok, bill_data}
    {:error, reason}
  """
  def start_fetch_bill_data(congress, type, bill_number, owner) do
    Task.start_link(__MODULE__, :fetch_bill_data, [congress, type, bill_number, owner])
  end

  def fetch_bill_data(congress, type, bill_number, owner) do
    response = case fetch_xml(congress, type, bill_number) do
      {:ok, %HTTPoison.Response{status_code: 200, body: xml}} -> {:ok, parse_xml_data(xml)}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
        _ -> {:error, :unknown}
    end

    send(owner, response)
  end

  defp fetch_xml(congress, type, bill_number) do
    generate_url(congress, type, bill_number)
    |> @http.get()
  end

  defp generate_url(congress, type, bill_number) do
    "https://www.gpo.gov/fdsys/bulkdata/BILLSTATUS/#{congress}/#{type}/BILLSTATUS-#{congress}#{type}#{bill_number}.xml"
  end

  defp parse_xml_data(xml) do
    xml 
     |> xpath(
        ~x"//bill",
        bill_number: ~x"./billNumber/text()"s,
        bill_type: ~x"./billType/text()"s,
        title: ~x"./title/text()"s,
        update_date: ~x"./updateDate/text()"s,
        congress: ~x"./congress/text()"s,
        policy_area: ~x"./policyArea/name/text()"s,
        actions: [
          ~x"./actions/item"l,
          action_date: ~x"./actionDate/text()"s,
          text: ~x"./text/text()"s,
          action_code: ~x"./actionCode/text()"s, # this can be nil
          committee: [
            ~x"./committee",
            system_code: ~x"./systemCode/text()"s,
            name: ~x"./name/text()"s
          ]
        ],
        subjects: [
          # TODO:
          # https://github.com/usgpo/bill-status/blob/master/BILLSTATUS-XML_User_User-Guide.md
          # seems to imply there are other types of subjects, but need to find example
          # otherwise we can collapse this a bit
          ~x"./subjects/billSubjects",
          legislative_subjects: [
            ~x"./legislativeSubjects/item"l,
            name: ~x"./name/text()"s
          ]
        ]
        # TODO: should we also capture relatedBill, summaries, or titles?
      )
  end
end
