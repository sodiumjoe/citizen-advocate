defmodule CitizenAdvocateDataFetcher.Propublica.WorkerTest do
  use ExUnit.Case, async: true

  alias CitizenAdvocateDataFetcher.Propublica.Worker, as: Worker

  test "responds with :not_found :error when making bad request"do
    assert {:reply, {:error, :not_found}, _} = Worker.handle_call({:fetch_members, {:congress, 666, :chamber, "not_found"}}, nil, %{})
  end

  test "responds with :forbidden :error when making request with bad api_key"do
    assert {:reply, {:error, :forbidden}, _} = Worker.handle_call({:fetch_members, {:congress, 666, :chamber, "forbidden"}}, nil, %{})
  end

  test "responds with :invalid :error when parsing bad json" do
    assert {:reply, {:error, {:invalid, _}}, _} = Worker.handle_call({:fetch_members, {:congress, 666, :chamber, "malformed"}}, nil, %{})
  end

  test "responds with member data when all is well" do
    case Worker.handle_call({:fetch_members, {:congress, 666, :chamber, "valid_member_json"}}, nil, %{}) do
    	{:reply, members, _} -> assert length(members) > 0
		error -> assert error == ""
	end
  end
end
