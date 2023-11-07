defmodule Sequence.Server do
  use GenServer

  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_call({:set_number, new_number}, _from, _current_number) do
    {:reply, new_number, new_number}
  end

  # does not return state???
  def handle_call({:factors_number, number}, _, current_number) do
    {:reply, {:factors_of, number, factors(number)}, current_number}
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
