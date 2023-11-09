defmodule Duper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @root_dir "."
  # @root_dir "/Volumes/Space/archive/media/photo/dadSulbalcon"
  # @root_dir "/Volumes/Space/archive/media/photo/catou"

  @impl true
  def start(_type, _args) do
    children = [
      Duper.Results,
      {Duper.PathFinder, @root_dir},
      Duper.WorkerSupervisor,
      {Duper.Gatherer, 1}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
