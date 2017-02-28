defmodule ActionDataFetcher.GPO.Parser.Worker do
  use GenServer
  import SweetXml

  ## Worker API

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok)
  end
  
  def handle_call({:parse_bill, {:filepath, bill_data_xml_path}}, _from, state) do
    case File.read(Path.expand(bill_data_xml_path)) do
        {:ok, binary} ->
          case parse_xml_data(binary) do
              {:fatal, reason} -> {:stop, reason, state}
              bill_data -> {:reply, bill_data, state}
          end
        {:error, reason} -> {:stop, reason, state}
    end
  end

  ## Internal Helpers

  defp parse_xml_data(xml) do
    try do
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
    catch 
      :exit, reason -> reason
    end
  end
end
