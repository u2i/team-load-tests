defmodule LoadTests.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LoadTestsWeb.Telemetry,
      LoadTests.Repo,
      {DNSCluster, query: Application.get_env(:load_tests, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LoadTests.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LoadTests.Finch},
      # Start a worker by calling: LoadTests.Worker.start_link(arg)
      # {LoadTests.Worker, arg},
      # Start to serve requests, typically the last entry
      LoadTestsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LoadTests.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LoadTestsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
