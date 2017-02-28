defmodule ActionDataFetch.GPO.Fetcher.WorkerTest do
  use ExUnit.Case, async: true

  alias ActionDataFetcher.GPO.Fetcher.Worker, as: GPO 

  test "responds with :not_found :error when making bad request"do
    assert {:reply, {:error, :not_found}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "not_found"}}, nil, %{})
  end

  test "responds with :unknown :error when receiving bad response"do
    assert {:reply, {:error, :unknown}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "unknown"}}, nil, %{})
  end

  test "responds with :nocreate :error when there is a problem making directory" do
    assert {:reply, {:error, {:no_create, :reason, _, :path, _}}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "no_create"}}, nil, %{})
  end

  test "responds with :nowrite :error when there is a problem writing zip" do
    assert {:reply, {:error, {:no_write, :reason, _, :path, _}}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "no_write"}}, nil, %{})
  end

  test "responds with :nounzip :error when there is a problem writing zip" do
    assert {:reply, {:error, {:no_unzip, :reason, _, :path, _}}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "no_unzip"}}, nil, %{})
  end

  test "responds with :unknown :nounzip :error when there is completely unexpected problem writing zip" do
    assert {:reply, {:error, {:no_unzip, :reason, :unknown, :path, _}}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "no_unzip_unknown"}}, nil, %{})
  end

  test "responds with :norm :error when unable to rm zip" do
    assert {:reply, {:error, {:no_rm, :reason, _, :path, _}}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "no_rm"}}, nil, %{})
  end

  test "responds with :ok :path when all is well" do
    assert {:reply, {:ok, _}, _} = GPO.handle_call({:fetch_bills, {:congress, 666, :bill_type, "good"}}, nil, %{})
  end
end
