defmodule SuperSeed.MixProject do
  use Mix.Project

  def project do
    [
      app: :super_seed,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      #mod: {SuperSeed.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "ecto.clean": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "ecto.trunc": ["cmd ./scripts/truncate_tables.sh"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10", only: [:test]},
      {:postgrex, ">= 0.0.0", only: [:test]},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.7", only: [:test]},
      {:faker, "~> 0.18", only: [:test]}
    ]
  end
end
