# elixir -r lib/chain.exs  -e 'Chain.run(10)'
# elixir -r lib/chain.exs  -e 'Chain.run(100)'
# elixir -r lib/chain.exs  -e 'Chain.run(1000)'
# elixir --erl '+P 1000000' -r lib/chain.exs  -e 'Chain.run(100_000)'
# elixir --erl '+P 1000000' -r lib/chain.exs  -e 'Chain.run(1_000_000)'
defmodule Chain do
  def counter(next_pid) do
    # IO.puts(
    #   "I am a counter(#{inspect(self())}), when I receive I will forward to #{inspect(next_pid)}, but for now I will wait to recieve a message"
    # )

    receive do
      n ->
        # IO.puts("I received #{n} and will now send #{n + 1} to #{inspect(next_pid)}")
        send(next_pid, n + 1)
    end
  end

  def create_processes(n) do
    IO.puts("Creating #{n} procecsses")

    code_to_run = fn _, send_to ->
      spawn(Chain, :counter, [send_to])
    end

    # last = Enum.reduce(1..n, self(), code_to_run)
    last =
      Enum.reduce(1..n, self(), fn elem, acc ->
        # IO.puts("Creating process #{elem} and returning PID #{inspect(acc)} as accumulator")
        code_to_run.(elem, acc)
      end)

    # IO.puts("Kick thing off by sending 0 to #{inspect(last)}")
    send(last, 0)

    receive do
      final_answer when is_integer(final_answer) ->
        IO.puts(
          "I am #{inspect(self())}, final reciever! I received #{final_answer} and will now return it"
        )

        "Result is #{inspect(final_answer)}"
    end
  end

  def run(n) do
    # IO.puts(inspect(:timer.tc(Chain, :create_processes, [n])))
    {micros, result} = :timer.tc(Chain, :create_processes, [n])
    IO.puts("Result is #{result}")

    IO.puts(
      "That took #{micros}us == #{micros / 1_000_000}s, rate is #{Float.round(n / (micros / 1_000_000), 2)} msg/s"
    )
  end
end
