defmodule FibSolver do
  @moduledoc false
  def fib(scheduler) do
    # IO.puts("FibSolver is ready")
    send(scheduler, {:ready, self()})

    receive do
      {:fib, n, client} ->
        send(client, {:answer, n, fib_calc(n), self()})
        fib(scheduler)

      {:shutdown} ->
        # IO.puts("FibSolver is done")
        exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule Scheduler do
  @moduledoc false
  def run(num_processes, module, func, to_calculate) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    # IO.puts(
    #   "processes: #{length(processes)} |queue|: #{length(queue)} results: #{length(results)}}"
    # )

    receive do
      # {:ready, pid} when queue! = [] ->
      {:ready, pid} when length(queue) > 0 ->
        [next | tail] = queue
        send(pid, {:fib, next, self()})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end

defmodule Runner do
  @moduledoc false
  def run do
    # a bit larger than my cpu count (which is 10)
    max_processes = 12

    # at least 37 for timing to be meaningful
    fibonaci_size_that_matters = 39
    how_many_times = 20

    to_process = List.duplicate(fibonaci_size_that_matters, how_many_times)

    # Print Running parameters; max_processes, how_many_times, fibonaci_size_that_matters
    IO.puts(
      "Calculating fibonaci number (#{fibonaci_size_that_matters}) #{length(to_process)} times"
    )

    IO.puts("Timing with 1..#{max_processes} processes")

    Enum.each(1..max_processes, fn num_processes ->
      {time, _result} = :timer.tc(Scheduler, :run, [num_processes, FibSolver, :fib, to_process])

      if num_processes == 1 do
        # IO.puts(inspect(result))
        IO.puts("\n #   time (s)")
      end

      :io.format("~2B     ~.2f~n", [num_processes, time / 1_000_000.0])
    end)
  end
end
