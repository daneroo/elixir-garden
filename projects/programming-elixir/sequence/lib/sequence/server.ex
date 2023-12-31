defmodule Sequence.Server do
  @moduledoc false
  use GenServer

  #### External API ####

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def next_number() do
    GenServer.call(__MODULE__, :next_number)
  end

  def set_number(new_number) do
    GenServer.call(__MODULE__, {:set_number, new_number})
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  #### GenServer callbacks ####
  def init(_) do
    {:ok, Sequence.Stash.get()}
  end

  def handle_cast({:increment_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_call({:set_number, new_number}, _from, _current_number) do
    {:reply, new_number, new_number}
  end

  def handle_call({:factors_number, number}, _, current_number) do
    {:reply, {:factors_of, number, factors(number)}, current_number}
  end

  def terminate(_reason, current_number) do
    Sequence.Stash.update(current_number)
  end

  def factors(number) when number > 0 do
    max_divisor = :math.sqrt(number) |> floor()

    1..max_divisor
    |> Enum.flat_map(fn x ->
      if rem(number, x) == 0 do
        if x == div(number, x) do
          # x is the square root of number
          [x]
        else
          [x, div(number, x)]
        end
      else
        []
      end
    end)
    |> Enum.sort()
  end
end
