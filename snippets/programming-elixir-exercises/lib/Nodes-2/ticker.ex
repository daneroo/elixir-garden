defmodule Ticker do
  @moduledoc false

  # 2 seconds
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 100])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator(clients, counter) do
    receive do
      {:register, pid} ->
        IO.puts("registering #{inspect(pid)}")
        generator(clients ++ [pid], counter)
    after
      @interval ->
        IO.puts("server:tick #{counter}")

        Enum.with_index(clients)
        |> Enum.each(fn {client, index} ->
          # this variant sends to all clients
          # should_send = true
          # this variant sends to every client, but in turn
          should_send = rem(counter, length(clients)) == index

          if should_send do
            IO.puts("server:sending to client number #{index} #{inspect(client)}")
            send(client, {:tick, counter})
          end
        end)

        generator(clients, counter + 1)
    end
  end
end

defmodule Client do
  @moduledoc false
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick, counter} ->
        IO.puts("client:tock #{counter}")
        receiver()

      msg ->
        IO.puts("client:unknown message: #{inspect(msg)}")
    end
  end
end
