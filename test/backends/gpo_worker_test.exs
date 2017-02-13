defmodule Action.Backends.DataFetch.GPO.WorkerTest do
  use ExUnit.Case, async: true

  alias Action.DataFetch.GPO.Worker, as: GPO

  test "responds with a Map of parsed data for succesful request" do
    {:ok, _} = GPO.start_fetch_bill_data(115, "hr", 100, self())

    assert_receive {:ok, %{
      actions: _,
      bill_number: "100",
      bill_type: _,
      congress: "115",
      policy_area: _,
      subjects: _,
      title: _,
      update_date: _
    }}
  end

  test "replies with :not_found for invalid request" do
    {:ok, _} = GPO.start_fetch_bill_data(3000, "hr", 100, self())

    assert_receive {:error, :not_found}
  end
end
