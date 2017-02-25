defmodule ActionDataFetcher.Test.HTTPClient do
  import HTTPoison.Response

  @gpo_bill_xml File.read!("test/fixtures/BILLSTATUS-115hr100.xml")

  def get(url, _opts) do
    cond do
      String.contains?(url, "BILLSTATUS-115hr100.xml") -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
      String.contains?(url, "BILLSTATUS-666-invalid.zip") -> {:ok, %HTTPoison.Response{status_code: 404}}
      String.contains?(url, "BILLSTATUS-666-not_found.zip") -> {:ok, %HTTPoison.Response{status_code: 404}}
      String.contains?(url, "BILLSTATUS-666-unknown.zip") -> {:ok, %HTTPoison.Response{status_code: 500}}
      true -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
    end
  end
end
