defmodule Stack.Server do
  @moduledoc false
  use GenServer

  #### External API ####

  def start_link(initial_number) do
    GenServer.start_link(__MODULE__, initial_number, name: __MODULE__)
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  #### GenServer Callbacks ####

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

  def terminate(reason, state) do
    IO.puts("Reason: #{inspect(reason)}; State: #{inspect(state)}")
  end
end
