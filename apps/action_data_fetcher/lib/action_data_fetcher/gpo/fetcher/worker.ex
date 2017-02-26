defmodule ActionDataFetcher.GPO.Fetcher.Worker do
  use GenServer

  @http Application.get_env(:action_data_fetcher, :gpo)[:http_client] || HTTPoison
  @file_module Application.get_env(:action_data_fetcher, :gpo)[:file_module] || File
  @sys_module Application.get_env(:action_data_fetcher, :gpo)[:sys_module] || System
  @tmp_dir Application.get_env(:action_data_fetcher, :tmp_dir)

  defmodule FetchState do
    defstruct [:congress, :bill_type, :zip_data]
  end

  def start_link(stuff) do
    GenServer.start_link(__MODULE__, stuff)
  end
  
  def fetch_bills(pid, congress, bill_type) do
    GenServer.call(pid, {:fetch_bills, {:congress, congress, :bill_type, bill_type}})
  end

  def init(_state) do
    {:ok, %FetchState{}}
  end

  def handle_call({:fetch_bills, {:congress, congress, :bill_type, bill_type}}, _from, _state) do
    {:reply, fetch_bills(congress, bill_type), %FetchState{}}
  end

  defp fetch_bills(congress, bill_type) do
	case fetch_zip(congress, bill_type) do
      {:ok, %HTTPoison.Response{status_code: 200, body: zip}} ->
        write_zip_to_tmpdir(congress, bill_type, zip)
        |> unzip_bill_data
        |> cleanup
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
        _ -> {:error, :unknown}
    end
  end

  defp fetch_zip(congress, type) do
    generate_url(congress, type) 
    |> @http.get([timeout: 90_000]) # TODO: Magic constant
  end

  defp generate_url(congress, bill_type) do
    "https://www.gpo.gov/fdsys/bulkdata/BILLSTATUS/#{congress}/#{bill_type}/BILLSTATUS-#{congress}-#{bill_type}.zip"
  end

  defp write_zip_to_tmpdir(congress, bill_type, zip_data) do
    date_time_str = String.replace(DateTime.to_string(DateTime.utc_now()), " ", "_")
    path          = Path.join([@tmp_dir, Integer.to_string(congress), bill_type])
    file_path     = Path.join([path, "#{date_time_str}.zip"])

    case @file_module.mkdir_p(path) do
      :ok -> case @file_module.write(file_path, zip_data, [:binary, :write]) do
        :ok -> {:ok, file_path}
        {:error, reason} -> {:error, {:nowrite, :reason, reason, :path, file_path}}
      end
      {:error, reason} -> {:error, {:nocreate, :reason, reason, :path, path}}
    end
  end

  defp unzip_bill_data({:ok, path}) do
    unzip_basename = Path.basename(path, ".zip")
    unzip_dirname = Path.dirname(path)
    unzip_path = Path.join([unzip_dirname, unzip_basename])

    case @sys_module.cmd("unzip", [path, "-d", unzip_path]) do
      {_, 0} -> {:ok, {:zip_path, path, :unzip_dirpath, unzip_path}}
      # TODO: should this remove the zipfile and raise and exception?
      {:error, reason} -> {:error, {:nounzip, :reason, reason, :path, unzip_path}}
      _ -> {:error, {:nounzip, :reason, :unknown, :path, unzip_path}}
    end
  end

  defp unzip_bill_data({:error, reason}) do
    {:error, reason}
  end

  defp cleanup({:ok, {:zip_path, zip_path, :unzip_dirpath, unzip_dirpath}}) do
    case @file_module.rm(zip_path) do
      :ok -> {:ok, unzip_dirpath}
      {:error, reason} -> {:error, {:norm, :reason, reason, :path, zip_path}}
    end
  end

  defp cleanup({:error, reason}) do
    {:error, reason}
  end
end
