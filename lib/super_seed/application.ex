defmodule SuperSeed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # SuperSeed.Repo
      # Start other processes here if needed
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SuperSeed.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
