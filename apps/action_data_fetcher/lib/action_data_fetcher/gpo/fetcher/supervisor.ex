defmodule Action.DataFetch.GPO.Fetcher.Supervisor do
  use Supervisor

  @child_name Action.DataFetch.GPO.Fetcher.Worker 

  def start_link do
    IO.puts("SUP START")
    Supervisor.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def start_gpo_fetch do
    IO.puts("SUP FETCH START")

    case Supervisor.which_children(__MODULE__) do
      [] ->
        case Supervisor.start_child(__MODULE__, [%{}]) do
          {:ok, pid} ->
            IO.puts("new: #{inspect pid}")
            GenServer.call(pid, {:fetch_data, {115, "hr", 100}})
          {:error, reason} ->
            {:error, reason}
          :error -> IO.puts("bad: unknown")
          _ -> IO.puts("what?!?")
        end
      [{_, pid, _, _}] ->
        IO.puts("old: #{inspect pid}")
        GenServer.call(pid, {:fetch_data, {115, "hr", 100}})
    end
  end

  def init(stuff) do
    IO.puts("SUP INIT: #{inspect stuff}")
    children = [
      worker(@child_name, [], restart: :temporary)
    ]

    supervise(children, [strategy: :simple_one_for_one])
  end
end
