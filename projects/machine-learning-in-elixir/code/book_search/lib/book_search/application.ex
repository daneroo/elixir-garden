#---
# Excerpted from "Machine Learning in Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/smelixir for more book information.
#---
defmodule BookSearch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BookSearchWeb.Telemetry,
      # Start the Ecto repository
      BookSearch.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BookSearch.PubSub},
      {Nx.Serving,
       serving: BookSearch.Model.serving(defn_options: [compiler: EXLA]),
       batch_size: 16,
       batch_timeout: 100,
       name: BookSearchModel},
      # Start Finch
      {Finch, name: BookSearch.Finch},
      # Start the Endpoint (http/https)
      BookSearchWeb.Endpoint
      # Start a worker by calling: BookSearch.Worker.start_link(arg)
      # {BookSearch.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookSearchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
