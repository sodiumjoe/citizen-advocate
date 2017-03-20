use Mix.Config

config :citizen_advocate_notifier, :twilio,
  client: CitizenAdvocateNotifier.Test.Twilio.HTTPClient

# NOTE: since this is "secret", it's not stored in GitHub
#       if you need this, contact one of the contributors
#       to this project
import_config "test.secret.exs"
