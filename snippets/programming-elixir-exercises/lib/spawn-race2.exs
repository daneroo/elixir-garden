# elixir -r lib/spawn-race2.exs  -e 'SpawnRace2.run()'
defmodule SpawnRace2 do
  def run do
    betty = spawn(SpawnRace2, :betty, [])
    fred = spawn(SpawnRace2, :fred, [])

    send(betty, {self(), "betty"})
    send(fred, {self(), "fred"})

    receive do
      {_sender, "betty"} -> IO.puts("Betty replied first!")
      {_sender, "fred"} -> IO.puts("Fred replied first!")
    end

    receive do
      {_sender, "betty"} -> IO.puts("Betty replied second!")
      {_sender, "fred"} -> IO.puts("Fred replied second!")
    end
  end

  def betty do
    receive do
      {sender, "betty"} -> send(sender, {self(), "betty"})
    end
  end

  def fred do
    receive do
      {sender, "fred"} -> send(sender, {self(), "fred"})
    end
  end
end
