defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  # Replaced @github_url with private runtime function
  # @github_url Application.get_env(:issues, :github_url)

  @moduledoc """
  Handle the fetching of GitHub issues from API (json)
  e.g. Issues.GithubIssues.fetch("elixir-lang", "elixir")
    Issues.GithubIssues.fetch("daneroo", "elixir-garden")
  """

  def fetch(user, project) do
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
    # {:ok, :jsx.decode(body)}
    {:ok, Jason.decode!(body)}
  end

  # replace def handle_response(%{status_code: _, body: body}) do
  def handle_response({:ok, %{status_code: _, body: body}}) do
    # {:error, :jsx.decode(body)}
    {:error, Jason.decode!(body)}
  end

  def handle_response({:error, reason}) do
    {:error, reason}
  end
end
