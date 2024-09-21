#---
# Excerpted from "Machine Learning in Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/smelixir for more book information.
#---
defmodule BookSearch.Index do
  @moduledoc """
  Manages the Faiss index for similarity search.
  """
  @backup_every 2 * 60 * 60 * 1000

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def add(embedding, id) do
    GenServer.cast(__MODULE__, {:add, embedding, id})
  end

  def search(embedding, k) do
    GenServer.call(__MODULE__, {:search, embedding, k})
  end

  def backup(path) do
    GenServer.cast(__MODULE__, {:backup, path})
  end

  @impl true
  def init(opts) do
    dim = opts[:dim]
    type = opts[:type]
    path = opts[:path]

    index =
      if path != nil and File.exists?(path) do
        ExFaiss.Index.from_file(path, 0)
      else
        ExFaiss.Index.new(dim, type)
      end

    if path != nil do
      schedule_backup(path)
    end

    {:ok, %{index: index}}
  end

  defp schedule_backup(path) do
    Process.send_after(self(), {:backup_index, path}, @backup_every)
  end

  @impl true
  def handle_cast({:add, embedding, id}, %{index: index} = state) do
    index = ExFaiss.Index.add_with_ids(index, embedding, id)
    {:noreply, %{state | index: index}}
  end

  def handle_cast({:backup, path}, %{index: index} = state) do
    :ok = ExFaiss.Index.to_file(index, path)
    {:noreply, state}
  end

  @impl true
  def handle_call({:search, embedding, k}, _from, %{index: index} = state) do
    results = ExFaiss.Index.search(index, embedding, k)
    {:reply, results, state}
  end

  def handle_info({:backup_index, path}, %{index: index} = state) do
    :ok = ExFaiss.Index.to_file(index, path)
    schedule_backup(path)
    {:noreply, state}
  end
end