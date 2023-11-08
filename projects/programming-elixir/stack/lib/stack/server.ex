defmodule Stack.Server do
  @moduledoc false

  use GenServer

  def init(initial_stack) do
    {:ok, initial_stack}
  end

  # What to do when empty?
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end
end
