defmodule ActionDataFetcher.Test.HTTPClient do
  import HTTPoison.Response

  @gpo_bill_xml File.read!("test/fixtures/BILLSTATUS-115hr100.xml")

  def get(url) do
    cond do
      String.contains?(url, "BILLSTATUS-115hr100.xml") -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
      String.contains?(url, "BILLSTATUS-666-invalid.zip") -> {:ok, %HTTPoison.Response{status_code: 404}}
      true -> {:ok, %HTTPoison.Response{status_code: 404}}
    end
  end

  def get(url, _options) do
    cond do
      String.contains?(url, "BILLSTATUS-115hr100.xml") -> {:ok, %HTTPoison.Response{status_code: 200, body: @gpo_bill_xml}}
      String.contains?(url, "BILLSTATUS-666-invalid.zip") -> {:ok, %HTTPoison.Response{status_code: 404}}
      true -> {:ok, %HTTPoison.Response{status_code: 404}}
    end
  end
end
