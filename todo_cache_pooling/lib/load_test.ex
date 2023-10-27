# Very quick, inconclusive load test
#
# Start from command line with:
#   elixir --erl "+P 2000000" -S mix run -e LoadTest.run
#
# Note: the +P 2000000 sets maximum number of processes to 2 millions
defmodule LoadTest do
  # @total_processes 1_000_000
  # @interval_size 100_000
  @total_processes 30
  @interval_size 10

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
    IO.puts("Running interval #{inspect(interval)}")

    {time, _} =
      :timer.tc(fn ->
        interval
        |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
      end)

    IO.puts("#{inspect(interval)}: average put #{time / @interval_size} μs")

    {time, _} =
      :timer.tc(fn ->
        interval
        |> Enum.each(&Todo.Cache.server_process(cache, "cache_#{&1}"))
      end)

    IO.puts("#{inspect(interval)}: average get #{time / @interval_size} μs\n")
  end
end
