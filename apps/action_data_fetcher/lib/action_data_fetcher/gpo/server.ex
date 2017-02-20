defmodule ActionDataFetcher.GPO.Server do
  use GenServer

  @timeout 90_000
  @tmp_dir Application.get_env(:action_data_fetcher, :tmp_dir)

  defmodule State do
    defstruct fetchers: nil, max_fetchers: nil, waiting: nil
  end

  ## Client API
  
  def fetch_gpo_bill_data do
    GenServer.call(__MODULE__, {:fetch_bills_data}, @timeout)
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
  end

  ## Server API

  def init(nil) do
    state = %State{fetchers: [], max_fetchers: 5, waiting: []}

    send(self(), {:start_fetcher_pool})

    {:ok, state}
  end

  def handle_call({:fetch_bills_data}, _from, state) do
	tasks = Enum.map(["hr", "s", "hjres", "sjres"], fn(bill_type) ->
		Task.async(
          fn -> :poolboy.transaction(:gpo_fetchers,
			&(GenServer.call(&1, 
              {
                :fetch_bills, 
                {
                  :congress, 115, 
                  :bill_type, bill_type
                }
            }, @timeout)
          ), @timeout)
		end)
	end)

    # TODO: I think this is bunching up the steps...ideally we can process each as they come up...
	results = tasks
           |> Enum.map(fn(task) ->
              case Task.await(task, @timeout) do
                {:ok, {:data, zip, :congress, congress, :bill_type, bill_type}} ->
                  write_zip_to_tmpdir(zip, congress, bill_type)
                response -> response
              end
            end)
            |> Enum.map(fn(result) ->
              case result do
                {:ok, path} -> unzip_path(path)
                # TODO: should this just raise an exception?
                err -> err
              end
            end)
            |> Enum.map(fn(response = {:ok, xml_dir}) ->
              IO.puts("TODO: parse all the files in #{inspect xml_dir}")
              response
            end)

    {:reply, results, state}
  end

  def handle_info({:start_fetcher_pool}, state) do
    ActionDataFetcher.GPO.Supervisor.start_fetcher_pool
    {:noreply, state}
  end

  defp unzip_path(path) do
    unzip_basename = Path.basename(path, ".zip")
    unzip_dirname = Path.dirname(path)
    unzip_path = Path.join([unzip_dirname, unzip_basename])
    case System.cmd("unzip", [path, "-d", unzip_path]) do
      {_, 0} -> {:ok, {:path, unzip_path}}
      # TODO: should this remove the zipfile and raise and exception?
      {:error, reason} -> {:error, {:path, unzip_path, :reaason, reason}}
      _ -> {:error, {:path, unzip_path, :reason, :unknown}}
    end
  end

  defp write_zip_to_tmpdir(binary_data, congress, bill_type) do
    date_time_str = String.replace(DateTime.to_string(DateTime.utc_now()), " ", "_")
    path          = Path.join([@tmp_dir, "bill_data", Integer.to_string(congress), bill_type])
    file_path     = Path.join([path, "#{date_time_str}.zip"])

    case File.mkdir_p(path) do
      :ok -> case File.write(file_path, binary_data, [:binary, :write]) do
        :ok -> {:ok, file_path}
        {:error, reason} -> {:error, {:nowrite, reason, :path, file_path}}
      end
      {:error, reason} -> {:error, {:nocreate, reason, :path, path}}
    end
  end

end
