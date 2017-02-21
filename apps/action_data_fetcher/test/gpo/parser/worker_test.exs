defmodule ActionDataFetch.GPO.Parser.WorkerTest do
  use ExUnit.Case, async: true

  alias ActionDataFetcher.GPO.Parser.Worker, as: GPO 
  
  @valid_gpo_bill_fixture_path Path.join([
										   __DIR__,
										   "../../fixtures/BILLSTATUS-115hr100.xml"
										 ])
	@invalid_gpo_bill_fixture_path Path.join([
											__DIR__, 
											"../../fixtures/BILLSTATUS-115hr100.invalid.xml"
										  ])

  test "responds with a :reply and Map of parsed data for succesful request" do
    {:reply, bill_data, _} = GPO.handle_call({
		:parse_bill, 
		{:filepath, @valid_gpo_bill_fixture_path}
	}, nil, %{})

    assert %{
		actions: _,
		bill_number: "100",
		bill_type: _,
		congress: "115",
		policy_area: _,
		subjects: _,
		title: _,
		update_date: _
	  } = bill_data
  end

  test "replies with :stop for invalid request" do
    {:stop, reason, _} = GPO.handle_call({
		:parse_bill, 
		{:filepath, @invalid_gpo_bill_fixture_path}
	}, nil, %{})

    assert {{:endtag_does_not_match, _}, _, _, _} = reason
  end

  test "replies with :stop for missing file" do
	assert {:stop, :enoent, _} = GPO.handle_call({
		:parse_bill,
		{:filepath, "/INVALID/PATH.xml"}
	}, nil, %{})
  end
end
