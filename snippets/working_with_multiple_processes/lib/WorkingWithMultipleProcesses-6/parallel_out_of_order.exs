defmodule Parallel do
  @moduledoc false
  def pmap(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn elem ->
      spawn_link(fn ->
        # wait for a random amount of time
        :timer.sleep(Enum.random(1..100))

        send(me, {self(), fun.(elem)})
      end)
    end)
    # This is the bad match pattern, that is exposed by the randome sleep
    # |> Enum.map(fn _pid ->
    #   receive do
    #     {_pid, result} -> result
    #   end
    # end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, result} -> result
      end
    end)

    # now show the output
    |> (fn results -> IO.puts("Results: #{inspect(results)}") end).()
  end
end
