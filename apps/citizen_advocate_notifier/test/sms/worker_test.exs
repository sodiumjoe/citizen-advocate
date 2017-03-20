defmodule CitizenAdvocateNotifier.SMS.WorkerTest do
  use ExUnit.Case, async: true

  alias CitizenAdvocateNotifier.SMS.Worker

  test "sending invalid user" do
    request = {:send_action_sms, {:user, {:phone, "123-123-1234"}, :bill, {:id, "TEST-BILL-ID", :name, "TEST BILL NAME"}}}
    state = {:some, "state"}
    result = Worker.handle_call(request, {}, state)
    assert {:reply, :ok, new_state} = result 
    assert new_state == state
  end
end
