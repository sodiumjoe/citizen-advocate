use Mix.Config


config :citizen_advocate_notifier, :twilio,
  client: CitizenAdvocateNotifier.Twilio.HTTPClient,

# NOTE: since this is "secret", it's not stored in GitHub
#       if you need this, contact one of the contributors
#       to this project
import_config "dev.secret.exs"
