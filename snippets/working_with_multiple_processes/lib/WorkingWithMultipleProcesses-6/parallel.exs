defmodule Parallel do
  @moduledoc false
  def pmap(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn elem ->
      spawn_link(fn -> send(me, {self(), fun.(elem)}) end)
    end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, result} -> result
      end
    end)
    # now show the output
    |> (fn results -> IO.puts("Results: #{inspect(results)}") end).()
  end
end
