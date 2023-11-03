defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  # Replaced @github_url with private runtime function
  # @github_url Application.get_env(:issues, :github_url)

  @moduledoc """
  Handle the fetching of GitHub issues from API (json)
  e.g. Issues.GithubIssues.fetch("elixir-lang", "elixir")
    Issues.GithubIssues.fetch("daneroo", "elixir-garden")
  """

  def fetch(user, project) do
    Logger.info("Fetching #{user}/#{project}")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def github_url do
    Application.fetch_env!(:issues, :github_url)
  end

  def issues_url(user, project) do
    "#{github_url()}/repos/#{user}/#{project}/issues"
  end

  # replace def handle_response(%{status_code: 200, body: body}) do
  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Got response: status code: 200")
    Logger.debug("Got response: body:#{body}")
    {:ok, Jason.decode!(body)}
  end

  # replace def handle_response(%{status_code: _, body: body}) do
  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    Logger.warn("Got response: status code: #{status_code}")
    Logger.debug("Got response: body:#{body}")

    {:error, Jason.decode!(body)}
  end

  def handle_response({:error, reason}) do
    Logger.error("Got response: error: #{inspect(reason)}")
    {:error, reason}
  end
end
