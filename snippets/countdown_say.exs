defmodule Countdown do
  def sleep(seconds) do
    receive do
      after seconds*1000 -> nil
    end

  end

  def say(text) do
    # IO.puts("Saying #{text}")
    spawn(fn -> :os.cmd('say #{text}') end)
  end

  def timer do
    Stream.resource(
      fn ->
        {_h,_m,s} = :erlang.time()
        60 - s - 1
      end,
      fn
        0 -> {:halt, 0}
        count ->
          sleep(1)
          {[inspect(count)], count - 1}
      end,
      fn _ -> nil end
    )
  end
end

# Countdown.say("Ok, google")

# counter = Countdown.timer
# printer = counter |> Stream.each(&IO.puts/1)
# speaker = printer |> Stream.each(&Countdown.say/1)
# speaker |> Enum.take(5)

Countdown.timer
 |> Stream.each(&IO.puts/1)
 |> Stream.each(&Countdown.say/1)
 |> Enum.take(5)
