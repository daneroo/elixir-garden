# Very quick, inconclusive load test
#
# If you want a million @total_processes, Start from command line with:
#   elixir --erl "+P 2000000" -S mix run -e LoadTest.run
# Note: the +P 2000000 sets maximum number of processes to 2 million

defmodule LoadTest do
  @moduledoc false

  @total_processes 10_000
  @interval_size 1_000

  def run do
    {:ok, cache} = Todo.Cache.start()

    IO.puts(
      "Running load test with #{@total_processes} processes and interval size #{@interval_size}"
    )

    interval_count = round(@total_processes / @interval_size)
    Enum.each(0..(interval_count - 1), &run_interval(cache, make_interval(&1)))
  end

  defp make_interval(n) do
    start = n * @interval_size
    start..(start + @interval_size - 1)
  end

  defp run_interval(cache, interval) do
    {time, _} =
      :timer.tc(fn ->
        interval
        # |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
        |> Enum.each(fn num ->
          # IO.puts("Getting process #{num}")
          srv = Todo.Cache.server_process(cache, "cache_#{num}")
          # IO.puts("Storing todo item #{num}")
          Todo.Server.add_entry(srv, %{date: ~D[2023-10-27], title: "Load test #{num}"})
        end)
      end)

    IO.puts("#{inspect(interval)}: average add_entry #{time / @interval_size} μs")

    {time, _} =
      :timer.tc(fn ->
        interval
        # |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
        |> Enum.each(fn num ->
          # IO.puts("Getting process #{num}")
          srv = Todo.Cache.server_process(cache, "cache_#{num}")
          # IO.puts("Retreiving todo item #{num}")
          _items = Todo.Server.entries(srv, ~D[2023-10-27])
          # IO.puts("Retreived #{inspect(items)}")
        end)
      end)

    IO.puts("#{inspect(interval)}: average get #{time / @interval_size} μs\n")
  end
end
