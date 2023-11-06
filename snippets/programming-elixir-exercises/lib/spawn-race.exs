# elixir -r lib/spawn-race.exs
defmodule SpawnRace do
  def sendToken do
    receive do
      {sender, msg} ->
        send(sender, {:ok, "token: #{msg}"})
        sendToken()
    end
  end
end

### Spawn processes #1 and #2
pid1 = spawn(SpawnRace, :sendToken, [])
pid2 = spawn(SpawnRace, :sendToken, [])

### send unique token to process #1
send(pid1, {self(), "PLAYER 1"})

receive do
  {:ok, message} ->
    IO.puts(message)
end

### send unique token to process #2
send(pid2, {self(), "PLAYER 2"})

receive do
  {:ok, message} ->
    IO.puts(message)
end
