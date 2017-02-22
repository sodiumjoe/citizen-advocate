defmodule ActionDataFetch.GPO.Fetcher.WorkerTest do
  use ExUnit.Case, async: true

  alias ActionDataFetcher.GPO.Fetcher.Worker, as: GPO 

  test "responds with a :reply and Map of parsed data for succesful request" do
    assert {:reply, {:error, :not_found}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "foo"}}, nil, %{})
  end
end
