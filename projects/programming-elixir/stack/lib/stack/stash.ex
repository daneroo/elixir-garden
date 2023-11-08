defmodule Stack.Stash do
  @moduledoc false
  use GenServer

  #### External API ####

  def start_link(initial_stack) do
    IO.puts("Stack.Stash start_link |#{inspect(initial_stack)}|")
    GenServer.start_link(__MODULE__, initial_stack, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def update(new_stack) do
    GenServer.cast(__MODULE__, {:update, new_stack})
  end

  #### GenServer callbacks ####
  def init(initial_stack) do
    IO.puts("Stack.Stash init |#{inspect(initial_stack)}|")
    {:ok, initial_stack}
  end

  def handle_call(:get, _from, current_stack) do
    {:reply, current_stack, current_stack}
  end

  def handle_cast({:update, new_stack}, _current_number) do
    {:noreply, new_stack}
  end
end
