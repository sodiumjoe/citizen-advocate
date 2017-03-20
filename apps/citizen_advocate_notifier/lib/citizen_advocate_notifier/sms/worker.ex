defmodule CitizenAdvocateNotifier.SMS.Worker do
  use GenServer

  alias CitizenAdvocateNotifier.Twilio.HTTPClient, as: TwilioClient
    
  ## Handlers

  def handle_call({:send_action_sms, {:user, {:phone, phone}, :bill, bill}}, _from, state) do
    response = generate_message(bill)
                |> send_sms(phone)
    {:reply, response, state}
  end

  ## Internal Helpers

  defp generate_message({:id, id, :name, name}) do
    "TODO: GENERATE MESSAGE FOR BILL #{id} -> #{name}"
  end

  defp send_sms(message, phone) do
    TwilioClient.send_sms({:to, phone, :message, message})
  end
end
