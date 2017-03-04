defmodule CitizenAdvocateDataFetcher.Test.HTTPClient do
  import HTTPoison.Response

  @gpo_bill_xml File.read!("test/fixtures/BILLSTATUS-115hr100.xml")
  @propublica_member_json File.read!("test/fixtures/members.json")

  def get(url, _headers, _opts \\ %{}) do
    cond do
      String.contains?(url, "BILLSTATUS-115hr100.xml") -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
      String.contains?(url, "BILLSTATUS-666-invalid.zip") -> {:ok, %HTTPoison.Response{status_code: 404}}
      String.contains?(url, "not_found") -> {:ok, %HTTPoison.Response{status_code: 404}}
      String.contains?(url, "forbidden") -> {:ok, %HTTPoison.Response{status_code: 403}}
      String.contains?(url, "malformed_json") -> {:ok, %HTTPoison.Response{status_code: 200, body: "{foo:bar}"}}
      String.contains?(url, "valid_member_json") -> {:ok, %HTTPoison.Response{status_code: 200, body: @propublica_member_json}}
      String.contains?(url, "BILLSTATUS-666-unknown.zip") -> {:ok, %HTTPoison.Response{status_code: 500}}
      true -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
    end
  end
end
