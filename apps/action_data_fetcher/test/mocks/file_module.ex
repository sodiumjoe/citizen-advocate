defmodule ActionDataFetcher.Test.FileModule do

  def mkdir_p(path) do
    cond do
      String.match?(path, ~r/no_create/) -> {:error, "TEST MKDIR FAIL"}
      true -> :ok
    end
  end

  def write(path, _data, _opts) do
    cond do
      String.match?(path, ~r/no_write/) -> {:error, "TEST WRITE FAIL"}
      true -> :ok
    end
  end

  def rm(path) do
    cond do
      String.match?(path, ~r/no_rm/) -> {:error, "TEST RM FAIL"}
      true -> :ok
    end
  end
end
