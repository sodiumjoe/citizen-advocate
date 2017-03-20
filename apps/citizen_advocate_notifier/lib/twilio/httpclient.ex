defmodule CitizenAdvocateNotifier.Twilio.HTTPClient do

  @twilio_client Application.get_env(:citizen_advocate_notifier, :twilio)[:client] || ExTwilio.Message
  @from Application.get_env(:citizen_advocate_notifier, :twilio)[:from_number]
  
  @moduledoc """
  HTTP client for interactions with the Twilio service
  """

  @doc """
  Send an SMS `message` to a given `phone_number`
  
  Returns `:ok` for success and `{:error, message, code}` for failure

  """
  def send_sms({:to, phone_number, :message, message}) do
    @twilio_client.create(%{to: phone_number, from: @from, body: message })
  end
end
