defmodule TestConnectElastic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TestConnectElasticWeb.Telemetry,
      TestConnectElastic.Repo,
      TestConnectElastic.ElasticsearchCluster,
      {DNSCluster,
       query: Application.get_env(:test_connect_elastic, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TestConnectElastic.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TestConnectElastic.Finch},
      # Start a worker by calling: TestConnectElastic.Worker.start_link(arg)
      # {TestConnectElastic.Worker, arg},
      # Start to serve requests, typically the last entry
      TestConnectElasticWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestConnectElastic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestConnectElasticWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
