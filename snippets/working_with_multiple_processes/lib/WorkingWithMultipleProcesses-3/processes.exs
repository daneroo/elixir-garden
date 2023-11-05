# cd lib/WorkingWithMultipleProcesses-3/
# elixir -r processes.exs  -e 'Processes.run()'
defmodule Processes do
  @moduledoc false
  def run do
    IO.puts("Starting parent process.")

    spawn_link(Processes, :child, [self()])

    IO.puts("Parent process sleeping for 1 second.")
    :timer.sleep(1000)

    IO.puts("Parent process receive all.")
    loop_receive()
  end

  def loop_receive do
    receive do
      message ->
        IO.puts("Message: #{message}")
        loop_receive()
    after
      500 -> IO.puts("All messages received.")
    end
  end

  def child(parent) do
    IO.puts("Child process started. Sending message to parent.")
    send(parent, "Hello!")
    IO.puts("Child process about to exit.")
  end
end
