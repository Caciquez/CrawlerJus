defmodule CrawlerJus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      CrawlerJus.Repo,
      # Start the endpoint when the application starts
      CrawlerJusWeb.Endpoint,
      # Starts a worker by calling: CrawlerJus.Worker.start_link(arg)
      # {CrawlerJus.Worker, arg},
      {Redix, {redis_url(), [name: :redix]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CrawlerJus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CrawlerJusWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp redis_url do
    Application.get_env(:redix, :redis_url)
  end
end
