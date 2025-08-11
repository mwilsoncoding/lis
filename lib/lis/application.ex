defmodule LIS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LISWeb.Telemetry,
      LIS.Repo,
      {DNSCluster, query: Application.get_env(:lis, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LIS.PubSub},
      # Start a worker by calling: LIS.Worker.start_link(arg)
      # {LIS.Worker, arg},
      # Start to serve requests, typically the last entry
      LISWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LIS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LISWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
