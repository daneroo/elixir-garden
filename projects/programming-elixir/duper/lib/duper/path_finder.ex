defmodule Duper.PathFinder do
  @moduledoc false
  use GenServer
  @me __MODULE__

  ## API
  def start_link(root) do
    GenServer.start_link(__MODULE__, root, name: @me)
  end

  def next_path() do
    GenServer.call(@me, :next_path)
  end

  def init(path) do
    DirWalker.start_link(path)
  end

  ## Server
  def handle_call(:next_path, _from, dirwalker) do
    path =
      case DirWalker.next(dirwalker) do
        [path] -> path
        other -> other
      end

    {:reply, path, dirwalker}
  end
end
