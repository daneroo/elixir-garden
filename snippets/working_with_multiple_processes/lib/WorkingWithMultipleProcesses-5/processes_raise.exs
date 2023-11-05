defmodule Processes do
  @moduledoc false
  def run do
    IO.puts("Starting parent process.")

    spawn_monitor(Processes, :child, [self()])

    IO.puts("Parent process sleeping for 1 second.")
    :timer.sleep(1000)

    IO.puts("Parent process receive all.")
    loop_receive()
  end

  def loop_receive do
    receive do
      message ->
        case message do
          {:DOWN, _, :process, pid, :normal} ->
            IO.puts("Process #{inspect(pid)} died normally.")

          {:DOWN, _, :process, pid, reason} ->
            IO.puts("Process #{inspect(pid)} died abnormally with reason #{inspect(reason)}.")

          message when is_binary(message) ->
            IO.puts("Message: #{message}")

          message ->
            IO.puts("catch all (shouldn't happen): #{inspect(message)}")
        end

        loop_receive()
    after
      500 -> IO.puts("All messages received.")
    end
  end

  def child(parent) do
    IO.puts("Child process started. Sending message to parent.")
    send(parent, "Hello!")
    IO.puts("Child process about to raise an Error.")
    raise RuntimeError
  end
end
