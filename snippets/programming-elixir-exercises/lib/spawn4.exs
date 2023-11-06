defmodule Spawn4 do
  def greet do
    receive do
      {sender, msg} ->
        send(sender, {:ok, "Hello #{msg}"})
        greet()
    end
  end
end

# here is a client
pid = spawn(Spawn4, :greet, [])

send(pid, {self, "World!"})

receive do
  {:ok, msg} ->
    IO.puts(msg)
end

# never processed
send(pid, {self, "Kermit!"})

receive do
  {:ok, msg} ->
    IO.puts(msg)
after
  1000 ->
    IO.puts("The greeter has gone away")
end
