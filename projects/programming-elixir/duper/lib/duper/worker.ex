defmodule Duper.Worker do
  @moduledoc false
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_file, _) do
    Duper.PathFinder.next_path()
    |> add_result()
  end

  defp add_result(nil) do
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Duper.Gatherer.result(path, hash_of_file_at(path))
    send(self(), :do_one_file)
    {:noreply, nil}
  end

  defp hash_of_file_at(path) do
    File.stream!(path, [], 4096)
    |> Enum.reduce(:crypto.hash_init(:sha256), fn chunk, hash ->
      :crypto.hash_update(hash, chunk)
    end)
    |> :crypto.hash_final()
  end
end
