defmodule WordCounter do
  @moduledoc false
  def count(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:count, file, word, client} ->
        send(client, {:answer, file, word, count_word(file, word), self()})
        count(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  def count_word(file, word) do
    content = File.read!(file)
    tokens = String.split(content, word)
    length(tokens) - 1
  end
end

defmodule Scheduler do
  @moduledoc false
  def run(num_processes, module, func, directory, word) do
    {:ok, files} = File.ls(directory)
    files = Enum.map(files, fn file -> Path.join(directory, file) end)

    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(files, word, Map.new())
  end

  defp schedule_processes(processes, queue, word, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [next | tail] = queue
        send(pid, {:count, next, word, self()})
        schedule_processes(processes, tail, word, results)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, word, results)
        else
          results
        end

      {:answer, file, _word, result, _pid} ->
        schedule_processes(processes, queue, word, Map.put(results, file, result))
    end
  end
end

defmodule Runner do
  @moduledoc false
  def run do
    max_processes = 12
    directory = "test_files/"
    word = "cat"

    # Print Running parameters; max_processes, how_many_times, fibonaci_size_that_matters
    IO.puts("Counting occurrences of '#{word}' in all files in #{directory} directory")

    IO.puts("Timing with 1..#{max_processes} processes")

    Enum.each(1..max_processes, fn num_processes ->
      {time, result} =
        :timer.tc(Scheduler, :run, [num_processes, WordCounter, :count, directory, word])

      if num_processes == 1 do
        # IO.puts("\nInspecting the results:\n#{inspect(result)}\n\n")
        IO.puts("\n #   time (ms)")
      end

      :io.format("~2B     ~.2f~n", [num_processes, time / 1000.0])
    end)
  end
end

defmodule TextFileGenerator do
  @moduledoc false
  @sentences [
    "The cow jumped over the moon.",
    "The cat in the hat laid on the mat.",
    "This little piggy went to the market.",
    "It's a piece of cake to bake a pretty cake."
  ]
  @file_count 100
  @sentence_count 15000
  @file_name_prefix "file"
  @file_name_suffix ".txt"
  @output_directory "test_files"

  def main do
    File.mkdir_p(@output_directory)

    Enum.each(0..(@file_count - 1), fn file_index ->
      file_name =
        "#{@file_name_prefix}#{String.pad_leading(Integer.to_string(file_index), 3, "0")}#{@file_name_suffix}"

      file_path = Path.join(@output_directory, file_name)

      File.open(file_path, [:write], fn file ->
        Enum.each(1..@sentence_count, fn _ ->
          sentence_index = :rand.uniform(length(@sentences)) - 1
          IO.write(file, Enum.at(@sentences, sentence_index) <> "\n")
        end)
      end)
    end)
  end
end
