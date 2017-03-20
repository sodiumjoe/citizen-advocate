defmodule CitizenAdvocateNotifier.Test.Twilio.HTTPClient do

  def create(%{to: phone_number, from: from_number, body: message}) do
    cond do
      String.contains?(message, "no_sid") -> {:error, "The requested resource /2010-04-01/Messages.json was not found", 404}
      String.contains?(message, "bad_sid") -> {:error, "The requested resource /2010-04-01/Accounts/TEST_ACCOUNT_SID/Messages.json was not found", 404}
      String.contains?(message, "bad_auth") -> {:error, "Authentication Error - No password provided", 401}
      from_number == "+11231231234" -> {:error, "The 'From' number #{from_number} is not a valid phone number, shortcode, or alphanumeric sender ID.", 400}
      true -> :ok
    end
  end
end
