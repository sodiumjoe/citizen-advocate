Code.require_file "backends/http_client.exs", __DIR__

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Action.Repo, :manual)

