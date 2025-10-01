defmodule EduCount.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EduCountWeb.Telemetry,
      EduCount.Repo,
      {DNSCluster, query: Application.get_env(:edu_count, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EduCount.PubSub},
      # Start a worker by calling: EduCount.Worker.start_link(arg)
      # {EduCount.Worker, arg},
      # Start to serve requests, typically the last entry
      EduCountWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EduCount.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EduCountWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
