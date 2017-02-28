defmodule ActionDataFetcher.Test.System do

  def cmd("unzip", [path, "-d", _unzip_path]) do
    cond do
      String.match?(path, ~r/no_unzip_unknown/) -> :error
      String.match?(path, ~r/no_unzip/) -> {:error, "TEST UNZIP FAIL"}
      true -> {:ok, 0}
    end
  end
end
